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
        commit["message"] =~ /^Merge branch .*See merge request .*\!(\d+)$/m
        $1
      end.compact.map(&:to_i)
    end

    def generate_description(iids, template)
      merge_requests = Gitlab.merge_requests(@project_name, iids: iids)
      ERB.new(template, trim_mode: "-").result(binding).strip
    end

    def create_merge_request(source_branch:, target_branch:, title:, template:, labels:)
      iids = merge_request_iids_between(target_branch, source_branch)
      description = generate_description(iids, template)

      mr = find_current_release_mr(source_branch, target_branch)
      if mr.nil?
        options = {
          source_branch: source_branch,
          target_branch: target_branch,
          description:   description,
          labels:        labels,
        }
        Gitlab.create_merge_request(@project_name, title, options)
      else
        options = {
          title: title,
          description: apply_checkbox_statuses(description, mr.description)
        }
        Gitlab.update_merge_request(@project_name, mr.iid, options)
      end
    end

    # find release mr already exists
    def find_current_release_mr(source_branch, target_branch)
      Gitlab.merge_requests(@project_name, state: :opened).find do |mr|
        mr.source_branch == source_branch && mr.target_branch == target_branch
      end
    end

    def apply_checkbox_statuses(new_desc, old_desc)
      checked_iids = old_desc.split("\n").select{ |line| line.include?("[x]") }.map{ |line| /\!\d+/.match(line).to_a.first }.compact

      applied_lines = new_desc.split("\n").map do |line|
        iid = /\!\d+/.match(line).to_a.first
        if !iid.nil? && checked_iids.include?(iid)
          line.gsub(/^( *)(\d+?\.|-|\*) \[ \]/) { "#{$1}#{$2} [x]" }
        else
          line
        end
      end
      applied_lines.join("\n")
    end
  end
end
