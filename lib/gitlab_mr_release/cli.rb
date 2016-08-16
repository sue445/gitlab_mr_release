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
    option :source, aliases: "-s", desc: "Source branch (e.g. develop)"
    option :target, aliases: "-t", desc: "Target branch (e.g. master)"
    option :title,  desc: "MergeRequest title (default. 'Release :source -> :target')"
    option :labels, aliases: "-l", desc: "Labels for MR as a comma-separated list  (e.g. 'label1,label2')"
    def create
      Dotenv.load(*GITLAB_ENV_FILES)

      assert_env("GITLAB_API_ENDPOINT")
      assert_env("GITLAB_API_PRIVATE_TOKEN")
      assert_env("GITLAB_PROJECT_NAME")

      assert_option_or_env(:source, "DEFAULT_SOURCE_BRANCH")
      assert_option_or_env(:target, "DEFAULT_TARGET_BRANCH")

      template = File.read(template_file)

      project = GitlabMrRelease::Project.new(
        api_endpoint:  ENV["GITLAB_API_ENDPOINT"],
        private_token: ENV["GITLAB_API_PRIVATE_TOKEN"],
        project_name:  ENV["GITLAB_PROJECT_NAME"],
      )

      mr = project.create_merge_request(
        source_branch: source_branch,
        target_branch: target_branch,
        labels:        labels,
        title:         generate_title,
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

    private

    def assert_env(name)
      if !ENV[name] || ENV[name].empty?
        puts "Error: Environment variable #{name} is required"
        exit!
      end
    end

    def assert_option_or_env(option_name, env_name)
      option_or_env!(option_name, env_name)
    end

    def generate_title
      return options[:title] if options[:title]

      generate_default_title(
        title_template: ENV["DEFAULT_TITLE"],
        source_branch:  source_branch,
        target_branch:  target_branch,
      )
    end

    def generate_default_title(title_template:, source_branch:, target_branch:)
      title_template ||= DEFAULT_TITLE_TEMPLATE
      ERB.new(title_template).result(binding).strip
    end

    def template_file
      ENV["TEMPLATE_FILE"] || "#{__dir__}/../templates/gitlab_mr_release.md.erb"
    end

    def source_branch
      option_or_env(:source, "DEFAULT_SOURCE_BRANCH")
    end

    def target_branch
      option_or_env(:target, "DEFAULT_TARGET_BRANCH")
    end

    def labels
      option_or_env(:labels, "DEFAULT_LABELS")
    end

    def option_or_env(option_name, env_name, default = nil)
      return options[option_name] if options[option_name] && !options[option_name].empty?
      return ENV[env_name] if ENV[env_name] && !ENV[env_name].empty?
      default
    end

    def option_or_env!(option_name, env_name)
      value = option_or_env(option_name, env_name)
      return value if value

      puts "Error: --#{option_name} or #{env_name} is either required!"
      exit!
    end
  end
end
