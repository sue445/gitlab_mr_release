require "gitlab_mr_release/version"
require "gitlab_mr_release/project"

module GitlabMrRelease
  class InvalidApiVersionError < StandardError; end
end
