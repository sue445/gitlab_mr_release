require "logger"

describe GitlabMrRelease::Project do
  let(:project) do
    GitlabMrRelease::Project.new(
      api_endpoint:     api_endpoint,
      private_token:    private_token,
      project_name:     project_name,
    )
  end

  let(:api_endpoint)         { "http://example.com/api/v4" }
  let(:private_token)        { "XXXXXXXXXXXXXXXXXXX" }
  let(:project_name)         { "group/name" }
  let(:escaped_project_name) { "group%2Fname" }
  let(:web_url)              { "http://example.com/#{project_name}" }

  before do
    allow(project).to receive(:web_url) { web_url }
  end

  describe "#api_version" do
    subject { project.api_version }

    using RSpec::Parameterized::TableSyntax

    where(:api_endpoint, :expected) do
      "http://example.com/api/v4/" | 4
      "http://example.com/api/v4"  | 4
      "http://example.com/api/v3/" | 3
      "http://example.com/"        | 0
    end

    with_them do
      it { should eq expected }
    end
  end

  describe "#merge_request_iids_between" do
    subject { project.merge_request_iids_between(from, to) }

    context "with gitlab v9 merge commits" do
      before do
        stub_request(:get, "#{api_endpoint}/projects/#{escaped_project_name}/repository/compare?from=#{from}&to=#{to}").
          with(headers: { "Accept" => "application/json", "Private-Token" => private_token }).
          to_return(status: 200, body: read_stub("repository_compare.json"), headers: {})
      end

      let(:from) { "v0.0.2" }
      let(:to)   { "v0.0.3" }

      it { should contain_exactly(5, 6) }
    end

    context "with gitlab v9 and v10 merge commits" do
      before do
        stub_request(:get, "#{api_endpoint}/projects/#{escaped_project_name}/repository/compare?from=#{from}&to=#{to}").
          with(headers: { "Accept" => "application/json", "Private-Token" => private_token }).
          to_return(status: 200, body: read_stub("repository_compare_with_v9_and_v10.json"), headers: {})
      end

      let(:from) { "v0.0.3" }
      let(:to)   { "v0.0.4" }

      it { should contain_exactly(7, 28, 29) }
    end
  end

  describe "#generate_description" do
    subject { project.generate_description(iids, template) }

    let(:iids) { [5, 6] }

    let(:template) do
      <<-MARKDNWN.strip_heredoc
      # MergeRequests
      <% merge_requests.each do |mr| -%>
      * [ ] !<%= mr.iid %> <%= mr.title %> @<%= mr.author.username %>
      <% end -%>
      MARKDNWN
    end

    let(:description) do
      <<-MARKDNWN.strip_heredoc.strip
      # MergeRequests
      * [ ] !5 Add yes @sue445
      * [ ] !6 Add gogo @sue445
      MARKDNWN
    end

    let(:api_endpoint) { "http://example.com/api/v4" }

    before do
      stub_request(:get, "#{api_endpoint}/projects/#{escaped_project_name}/merge_requests?iids[]=5&iids[]=6").
        with(headers: { "Accept" => "application/json", "Private-Token" => private_token }).
        to_return(status: 200, body: read_stub("merge_requests_with_iids_5_and_6.json"), headers: {})
    end

    it { should eq description }
  end

  describe "#find_current_release_mr" do
    before do
      stub_request(:get, "#{api_endpoint}/projects/#{escaped_project_name}/merge_requests?state=opened").
        with(headers: { "Accept" => "application/json", "Private-Token" => private_token }).
        to_return(status: 200, body: read_stub("merge_requests_with_state_opened.json"), headers: {})
    end

    context("the release mr exists") do
      subject { project.find_current_release_mr("develop", "master") }
      it "returns an instance of mr" do
        mr = subject

        expect(mr).to be_an_instance_of Gitlab::ObjectifiedHash
        expect(mr.id).to eq 165679
      end
    end

    context("the release mr does not exist") do
      subject { project.find_current_release_mr("develop", "release") }
      it { should be_nil }
    end
  end

  describe "#apply_checkbox_statuses" do
    let(:new_description) do
      <<-MARKDNWN.strip_heredoc.strip
      # MergeRequests
      * [ ] !11 aaa
      * [ ] !12 bbb
      * [ ] !13 ccc
      * [ ] !14 ddd
      MARKDNWN
    end

    let(:old_description) do
      <<-MARKDNWN.strip_heredoc.strip
      # MergeRequests
      * [ ] !11 aaa
      * [x] !12 bbb
      * [x] !13 ccc
      MARKDNWN
    end

    let(:applied_descriptopn) do
      <<-MARKDNWN.strip_heredoc.strip
      # MergeRequests
      * [ ] !11 aaa
      * [x] !12 bbb
      * [x] !13 ccc
      * [ ] !14 ddd
      MARKDNWN
    end

    subject { project.apply_checkbox_statuses(new_description, old_description) }

    it { should eq applied_descriptopn }
  end
end
