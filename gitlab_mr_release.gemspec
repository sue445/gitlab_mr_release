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

  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://sue445.github.io/gitlab_mr_release/"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dotenv"
  spec.add_dependency "gitlab", ">= 4.0.0"
  spec.add_dependency "thor"

  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "bundler", ">= 1.10"
  spec.add_development_dependency "coveralls_reborn"
  spec.add_development_dependency "ostruct"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-parameterized"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "term-ansicolor", "!= 1.11.1" # ref. https://github.com/flori/term-ansicolor/issues/41
  spec.add_development_dependency "unparser", ">= 0.4.5"
  spec.add_development_dependency "webmock", ">= 3.0.0"
  spec.add_development_dependency "yard"
end
