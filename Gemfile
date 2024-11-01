source 'https://rubygems.org'

# Specify your gem's dependencies in gitlab_mr_release.gemspec
gemspec

if Gem::Version.create(RUBY_VERSION) < Gem::Version.create("2.2.2")
  group :development do
    # NOTE: activesupport 5.x supports only ruby 2.2.2+
    gem "activesupport", "< 5.0.0", group: :test
  end
end

if Gem::Version.create(RUBY_VERSION) < Gem::Version.create("2.3.0")
  # NOTE: httparty v0.19.0+ requires Ruby 2.3+
  gem "httparty", "< 0.19.0"

  # NOTE: webmock v3.15.0+ requires Ruby 2.3+
  gem "webmock", "< 3.15.0"

  # NOTE: logger v1.3.0+ requires Ruby 2.3+
  gem "logger", "< 1.3.0"
end

if Gem::Version.create(RUBY_VERSION) < Gem::Version.create("2.5.0")
  # NOTE: unparser v0.3.0+ requires Ruby 2.5+
  gem "unparser", "< 0.3.0"
end

if Gem::Version.create(RUBY_VERSION) < Gem::Version.create("2.4.0")
  # String#unpack1 is available since ruby 2.4, but gitlab gem uses String#unpack1 ...
  # c.f. https://github.com/NARKOZ/gitlab/commit/d9ef580#diff-84e3ba49bf244c6684f7d26a3312adc4R81
  gem "gitlab", "< 4.14.0"
end

if Gem::Version.create(RUBY_VERSION) < Gem::Version.create("2.7.0")
  # term-ansicolor 1.9.0+ doesn't work on Ruby < 2.7
  gem "term-ansicolor", "< 1.9.0"
end
