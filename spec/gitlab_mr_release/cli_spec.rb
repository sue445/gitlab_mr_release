describe GitlabMrRelease::CLI do
  let(:cli) { GitlabMrRelease::CLI.new }

  describe "#create" do
    subject do
      cli.invoke(
        :create,
        [],
        {
          source: source,
          target: target,
          labels: labels.join(","),
        }
      )
    end

    before do
      allow(Dotenv).to receive(:load)
      stub_const("ENV", env)
    end

    let(:env) do
      {
        "GITLAB_API_ENDPOINT"      => gitlab_api_endpoint,
        "GITLAB_API_PRIVATE_TOKEN" => gitlab_api_private_token,
        "GITLAB_PROJECT_NAME"      => gitlab_project_name,
      }
    end
    let(:gitlab_api_endpoint)      { "http://example.com/api/v4" }
    let(:gitlab_api_private_token) { "XXXXXXXXXXXXXXXXXXX" }
    let(:gitlab_project_name)      { "group/name" }

    let(:source)      { "develop" }
    let(:target)      { "master" }
    let(:labels)      { %w(label1 label2) }

    context "When valid api version" do
      let(:description) { "# MergeRequests"}

      let(:merge_request) do
        OpenStruct.new(
          iid:         1,
          title:       "Release develop -> master",
          description: description,
          labels:      labels,
        )
      end

      before do
        allow_any_instance_of(GitlabMrRelease::CLI).to receive(:assert_env)
        allow_any_instance_of(GitlabMrRelease::Project).to receive(:create_merge_request){ merge_request }
        allow_any_instance_of(GitlabMrRelease::Project).to receive(:web_url){ "http://example.com/your/project" }
      end

      it { expect { subject }.not_to raise_error  }
    end

    context "When invalid api version" do
      let(:gitlab_api_endpoint) { "http://example.com/api/v3" }

      it { expect { subject }.to raise_error GitlabMrRelease::InvalidApiVersionError }
    end
  end

  describe "#generate_default_title" do
    subject { cli.send(:generate_default_title, title_template: title_template, source_branch: source_branch, target_branch: target_branch) }

    let(:title_template) { "Release <%= source_branch %> -> <%= target_branch %>" }
    let(:source_branch) { "develop" }
    let(:target_branch) { "master" }

    it { should eq "Release develop -> master" }
  end
end
