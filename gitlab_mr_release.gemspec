# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitlab_mr_release/version'

Gem::Specification.new do |spec|
  spec.name          = "gitlab_mr_release"
  spec.version       = GitlabMrRelease::VERSION
  spec.authors       = ["sue445"]
  spec.email         = ["sue445@sue445.net"]

  spec.summary       = %q{Release MergeRequest generator for GitLab}
  spec.description   = %q{Release MergeRequest generator for GitLab}
  spec.homepage      = "https://github.com/sue445/gitlab_mr_release"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dotenv"
  spec.add_dependency "gitlab"
  spec.add_dependency "thor"

  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 1.0.0"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "webmock"
end
