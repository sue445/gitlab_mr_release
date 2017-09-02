source 'https://rubygems.org'

# Specify your gem's dependencies in gitlab_mr_release.gemspec
gemspec

if Gem::Version.create(RUBY_VERSION) < Gem::Version.create("2.2.2")
  # NOTE: activesupport 5.x supports only ruby 2.2.2+
  gem "activesupport", "< 5.0.0"
end

if Gem::Version.create(RUBY_VERSION) < Gem::Version.create("2.2.0")
  # NOTE: byebug 9.1.0+ requires ruby 2.2.0+
  gem "byebug", "< 9.1.0"
end
