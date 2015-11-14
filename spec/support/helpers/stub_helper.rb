module StubHelper
  def read_stub(filename)
    spec_dir.join("support/stub/#{filename}").read
  end
end
