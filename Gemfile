source 'https://rubygems.org'

# Specify your gem's dependencies in gitlab_mr_release.gemspec
gemspec

if Gem::Version.create(RUBY_VERSION) < Gem::Version.create("2.7.0")
  # term-ansicolor 1.9.0+ doesn't work on Ruby < 2.7
  gem "term-ansicolor", "< 1.9.0"
end

# FIXME: Workaround for Ruby 4.0+
# ref. https://github.com/banister/binding_of_caller/pull/90
gem "binding_of_caller", github: "kivikakk/binding_of_caller", branch: "push-yrnnzolypxun"
