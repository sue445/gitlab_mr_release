## Unreleased
[full changelog](http://github.com/sue445/gitlab_mr_release/compare/v2.0.1...master)

## [v2.0.1](https://github.com/sue445/gitlab_mr_release/releases/tag/v2.0.1)
[full changelog](http://github.com/sue445/gitlab_mr_release/compare/v2.0.0...v2.0.1)

* Release gem from GitHub Actions
  * https://github.com/sue445/gitlab_mr_release/pull/92

## v2.0.0
[full changelog](http://github.com/sue445/gitlab_mr_release/compare/v1.1.2...v2.0.0)

* Fix deprecation warning at `ERB.new` and requires Ruby 2.6+
  * https://github.com/sue445/gitlab_mr_release/pull/84

## v1.1.2
[full changelog](http://github.com/sue445/gitlab_mr_release/compare/v1.1.1...v1.1.2)

* Enable MFA requirement for gem releasing
  * https://github.com/sue445/gitlab_mr_release/pull/53

## v1.1.1
[full changelog](http://github.com/sue445/gitlab_mr_release/compare/v1.1.0...v1.1.1)

* Preserve checkbox statuses on update
  * https://github.com/sue445/gitlab_mr_release/pull/45

## v1.1.0
[full changelog](http://github.com/sue445/gitlab_mr_release/compare/v1.0.1...v1.1.0)

* Update the release MR when release MR is already exists
  * https://github.com/sue445/gitlab_mr_release/pull/41

## v1.0.1
[full changelog](http://github.com/sue445/gitlab_mr_release/compare/v1.0.0...v1.0.1)

* Support new merge commit format for GitLab v10.0.0+
  * https://github.com/sue445/gitlab_mr_release/pull/25

## v1.0.0
[full changelog](http://github.com/sue445/gitlab_mr_release/compare/v0.4.0...v1.0.0)

* Drop GitLab API v3 supports
  * https://github.com/sue445/gitlab_mr_release/pull/21
* Reduced API calls at `gitlab_mr_release create`
  * https://github.com/sue445/gitlab_mr_release/pull/23

## v0.4.0
[full changelog](http://github.com/sue445/gitlab_mr_release/compare/v0.3.1...v0.4.0)

* Support GitLab API v4
  * https://github.com/sue445/gitlab_mr_release/pull/19

## v0.3.1
[full changelog](http://github.com/sue445/gitlab_mr_release/compare/v0.3.0...v0.3.1)

* Fixed. can not call GitLab API using gitlab v4+
  * https://github.com/sue445/gitlab_mr_release/pull/18

## v0.3.0
[full changelog](http://github.com/sue445/gitlab_mr_release/compare/v0.2.0...v0.3.0)

* Support MR labels
  * https://github.com/sue445/gitlab_mr_release/pull/13
* Support default params in .env.gitlab
  * https://github.com/sue445/gitlab_mr_release/pull/14

## v0.2.0
[full changelog](http://github.com/sue445/gitlab_mr_release/compare/v0.1.1...v0.2.0)

* Support `DEFAULT_TITLE` with erb
  * https://github.com/sue445/gitlab_mr_release/pull/11

## v0.1.1
[full changelog](http://github.com/sue445/gitlab_mr_release/compare/v0.1.0...v0.1.1)

* Enable ERB trim_mode `"-"` (i.g. `<%-` , `-%>`) and tweak default template #10
  * https://github.com/sue445/gitlab_mr_release/pull/10

## v0.1.0
* First release
