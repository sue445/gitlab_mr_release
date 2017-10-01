module GitlabMrRelease
  require "gitlab"

  class Project
    # @param api_endpoint     [String]
    # @param private_token    [String]
    # @param project_name     [String]
    def initialize(api_endpoint:, private_token:, project_name:)
      Gitlab.configure do |config|
        config.endpoint      = api_endpoint
        config.private_token = private_token
      end
      @api_endpoint = api_endpoint
      @project_name = project_name
    end

    def api_version
      @api_endpoint =~ %r(/api/v([0-9]+)/?)
      $1.to_i
    end

    def web_url
      @web_url ||= Gitlab.project(@project_name).web_url
    end

    # find merge requests between from...to
    # @param from [String]
    # @param to   [String]
    # @return [Array<Integer>] MergeRequest iids
    def merge_request_iids_between(from, to)
      commits = Gitlab.repo_compare(@project_name, from, to).commits
      commits.map do |commit|
        commit["message"] =~ /^Merge branch .*See merge request \!(\d+)$/m
        $1
      end.compact.map(&:to_i)
    end

    # find MergeRequest with iid
    def merge_request(iid)
      if api_v4?
        # API v4
        Gitlab.merge_request(@project_name, iid)
      else
        # API v3
        mr = Gitlab.merge_requests(@project_name, iid: iid).first
        assert_merge_request_iid(mr, iid) if mr
        mr
      end
    end

    def generate_description(iids, template)
      merge_requests = iids.map { |iid| merge_request(iid) }
      ERB.new(template, nil, "-").result(binding).strip
    end

    def create_merge_request(source_branch:, target_branch:, title:, template:, labels:)
      iids = merge_request_iids_between(target_branch, source_branch)
      options = {
        source_branch: source_branch,
        target_branch: target_branch,
        description:   generate_description(iids, template),
        labels:        labels,
      }
      Gitlab.create_merge_request(@project_name, title, options)
    end

    private

    def assert_merge_request_iid(mr, iid)
      # NOTE: MR is found, but server is old GitLab?
      raise "MergeRequest iid does not match (expected #{iid}, but #{mr.iid})" unless iid == mr.iid
    end

    def api_v4?
      @api_endpoint =~ %r(/api/v4/?)
    end
  end
end
