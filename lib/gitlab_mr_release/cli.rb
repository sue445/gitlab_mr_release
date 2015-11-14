require "gitlab_mr_release"
require "thor"
require "dotenv"

module GitlabMrRelease
  class CLI < Thor
    include Thor::Actions

    GITLAB_ENV_FILES = %w(.env.gitlab ~/.env.gitlab)

    DEFAULT_TEMPLATE = <<-MARKDOWN
# MergeRequests
<% merge_requests.each do |mr| %>
* [ ] !<%= mr.iid %> <%= mr.title %>
<% end %>
    MARKDOWN

    def self.source_root
      "#{__dir__}/../templates"
    end

    desc "version", "Show gitlab_mr_release version"
    def version
      puts GitlabMrRelease::VERSION
    end

    desc "init", "Copy setting files to current directory"
    def init
      copy_file ".env.gitlab", ".env.gitlab"
      copy_file "gitlab_mr_release.md.erb", "gitlab_mr_release.md.erb"
    end

    desc "create", "Create merge requrst"
    option :source, aliases: "-s", required: true, desc: "Source branch (e.g. develop)"
    option :target, aliases: "-t", required: true, desc: "Target branch (e.g. master)"
    option :title,  desc: "MergeRequest title (default. 'Release :source -> :target')"
    def create
      title = options[:title] || default_title

      template =
        if ENV["TEMPLATE_FILE"]
          File.read(ENV["TEMPLATE_FILE"])
        else
          DEFAULT_TEMPLATE
        end

      project = GitlabMrRelease::Project.new(
        api_endpoint:  ENV["GITLAB_API_ENDPOINT"],
        private_token: ENV["GITLAB_API_PRIVATE_TOKEN"],
        project_name:  ENV["GITLAB_PROJECT_NAME"],
      )
      project.create_merge_request(
        source_branch: options[:source],
        target_branch: options[:target],
        title:         title,
        template:      template,
      )
    end

    private

    def default_title
      "Release #{options[:source]} -> #{options[:target]}"
    end
  end
end
