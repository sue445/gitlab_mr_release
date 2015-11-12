require "logger"

describe GitlabMrRelease::Project do
  let(:project) do
    GitlabMrRelease::Project.new(
      api_endpoint:     api_endpoint,
      private_token:    private_token,
      project_name:     project_name,
      logger:           logger,
    )
  end

  let(:api_endpoint)         { "http://example.com/api/v3" }
  let(:private_token)        { "XXXXXXXXXXXXXXXXXXX" }
  let(:project_name)         { "group/name" }
  let(:escaped_project_name) { "group%2Fname" }
  let(:web_url)              { "http://example.com/#{project_name}" }
  let(:logger) do
    _logger = Logger.new(STDOUT)
    _logger.level = Logger::ERROR
    _logger
  end

  before do
    allow(project).to receive(:web_url) { web_url }
  end

  describe "#merge_request_iids_between" do
    subject { project.merge_request_iids_between(from, to) }

    before do
      stub_request(:get, "#{api_endpoint}/projects/#{escaped_project_name}/repository/compare?from=#{from}&to=#{to}").
        with(headers: { "Accept" => "application/json", "Private-Token" => private_token }).
        to_return(status: 200, body: read_stub("repository_compare.json"), headers: {})
    end

    let(:from) { "v0.0.2" }
    let(:to)   { "v0.0.3" }

    it { should contain_exactly(5, 6) }
  end
end
