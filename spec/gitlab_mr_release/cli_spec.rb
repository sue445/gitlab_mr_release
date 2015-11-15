describe GitlabMrRelease::CLI do
  describe "#create" do
    subject do
      GitlabMrRelease::CLI.new.invoke(
        :create,
        [],
        {
          source: source,
          target: target,
        }
      )
    end

    let(:source)      { "develop" }
    let(:target)      { "master" }
    let(:description) { "# MergeRequests"}

    let(:merge_request) do
      OpenStruct.new(
        iid:         1,
        title:       "Release develop -> master",
        description: description,
      )
    end

    before do
      allow_any_instance_of(GitlabMrRelease::CLI).to receive(:assert_env)
      allow_any_instance_of(GitlabMrRelease::Project).to receive(:create_merge_request){ merge_request }
      allow_any_instance_of(GitlabMrRelease::Project).to receive(:web_url){ "http://example.com/your/project" }
    end

    it { expect { subject }.not_to raise_error  }
  end
end
