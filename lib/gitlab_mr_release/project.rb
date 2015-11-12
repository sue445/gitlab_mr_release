module GitlabMrRelease
  require "gitlab"

  class Project
    # @param api_endpoint     [String]
    # @param private_token    [String]
    # @param project_name     [String]
    # @param allow_tag_format [Regexp]
    def initialize(api_endpoint:, private_token:, project_name:, logger:)
      Gitlab.configure do |config|
        config.endpoint      = api_endpoint
        config.private_token = private_token
      end
      @project_name = project_name
      @logger = logger
    end

    def web_url
      @web_url ||= Gitlab.project(escaped_project_name).web_url
    end

    # find merge requests between from...to
    # @param from [String]
    # @param to   [String]
    # @return [Array<Integer>] MergeRequest iids
    def merge_request_iids_between(from, to)
      commits = Gitlab.repo_compare(escaped_project_name, from, to).commits
      commits.map do |commit|
        commit["message"] =~ /^Merge branch .*See merge request \!(\d+)$/m
        $1
      end.compact.map(&:to_i)
    end

    # find MergeRequest with iid
    def merge_request(iid)
      mr = Gitlab.merge_requests(escaped_project_name, iid: iid).first
      assert_merge_request_iid(mr, iid) if mr
      mr
    end

    private

    def escaped_project_name
      CGI.escape(@project_name)
    end

    def assert_merge_request_iid(mr, iid)
      # NOTE: MR is found, but server is old GitLab?
      raise "MergeRequest iid does not match (expected #{iid}, but #{mr.iid})" unless iid == mr.iid
    end
  end
end
