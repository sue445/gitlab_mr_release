require "gitlab_mr_release"
require "thor"
require "dotenv"

module GitlabMrRelease
  class CLI < Thor
    include Thor::Actions

    GITLAB_ENV_FILES = %w(.env.gitlab ~/.env.gitlab)

    DEFAULT_TITLE_TEMPLATE = "Release <%= Time.now %> <%= source_branch %> -> <%= target_branch %>"

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
      Dotenv.load(*GITLAB_ENV_FILES)

      assert_env("GITLAB_API_ENDPOINT")
      assert_env("GITLAB_API_PRIVATE_TOKEN")
      assert_env("GITLAB_PROJECT_NAME")

      title = options[:title] || default_title

      template = File.read(template_file)

      project = GitlabMrRelease::Project.new(
        api_endpoint:  ENV["GITLAB_API_ENDPOINT"],
        private_token: ENV["GITLAB_API_PRIVATE_TOKEN"],
        project_name:  ENV["GITLAB_PROJECT_NAME"],
      )

      mr = project.create_merge_request(
        source_branch: options[:source],
        target_branch: options[:target],
        title:         title,
        template:      template,
      )

      mr_url = "#{project.web_url}/merge_requests/#{mr.iid}"

      message = <<-EOS
MergeRequest is created

[Title] #{mr.title}

[Description]
#{mr.description}

[Url] #{mr_url}
      EOS

      puts message
    end

    def generate_default_title(title_template:, source_branch:, target_branch:)
      title_template ||= DEFAULT_TITLE_TEMPLATE
      ERB.new(title_template).result(binding).strip
    end

    private

    def assert_env(name)
      raise "Error: Environment variable #{name} is required" unless ENV[name]
    end

    def default_title
      "Release #{options[:source]} -> #{options[:target]}"
    end

    def template_file
      ENV["TEMPLATE_FILE"] || "#{__dir__}/../templates/gitlab_mr_release.md.erb"
    end
  end
end
