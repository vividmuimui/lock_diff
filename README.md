# LockDiff

[![Gem Version](https://badge.fury.io/rb/lock_diff.svg)](https://badge.fury.io/rb/lock_diff)
[![GitHub tag](https://img.shields.io/github/tag/vividmuimui/lock_diff.svg)](https://github.com/vividmuimui/lock_diff/tags)
[![Build Status](https://travis-ci.org/vividmuimui/lock_diff.svg?branch=master)](https://travis-ci.org/vividmuimui/lock_diff)
[![Dependency Status](https://gemnasium.com/badges/github.com/vividmuimui/lock_diff.svg)](https://gemnasium.com/github.com/vividmuimui/lock_diff)
[![Code Climate](https://codeclimate.com/github/vividmuimui/lock_diff/badges/gpa.svg)](https://codeclimate.com/github/vividmuimui/lock_diff)
[![Issue Count](https://codeclimate.com/github/vividmuimui/lock_diff/badges/issue_count.svg)](https://codeclimate.com/github/vividmuimui/lock_diff)
[![ghit.me](https://ghit.me/badge.svg?repo=vividmuimui/lock_diff)](https://ghit.me/repo/vividmuimui/lock_diff)

This gem detects changes to your package manager (e.g. Gemfile) and generates a Markdown-formatted diff including:

* links to the corresponding package's change logs
* Github `...`-delineated diff links for the relevant changes

It also optionally posts the diff as a comment to the pull request responsible for the package update.

Like this.

> https://github.com/vividmuimui/lock_diff_sample/pull/9#issuecomment-315140796
> ![image](https://user-images.githubusercontent.com/1803598/28178302-eeef61f4-6838-11e7-8c41-bd13195bef6d.png)

## Strategies

- Gemfile.lock(Ruby/Bundler)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lock_diff'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lock_diff

## Usage

lock_diff requires you to provide a `GITHUB_ACCESS_TOKEN` as an environment variable.

### Command line

```sh
$ lock_diff
Usage: lock_diff [options]
Require flags
    -r, --repository=REPOSITORY      Like as "user/repository"
    -n, --number=PULL_REQUEST_NUMBER

Optional flags
        --post-comment=true or false Print result to stdout when false. (default is false)
    -v, --verbose                    Run verbosely
        --version                    Show version
```

For example, to comment on https://github.com/vividmuimui/lock_diff_sample/pull/9#issuecomment-315140796, run this command:

```sh
$ lock_diff -r "vividmuimui/lock_diff_sample" -n 9 --post-comment=false
```

### Ruby

```ruby
require 'lock_diff'
LockDiff.run(repository: "vividmuimui/lock_diff_sample", number: 9, post_comment: false)
```

### For Tachikoma pull request

When used in conjunction with [tachikoma](https://rubygems.org/gems/tachikoma), use the `lock_diff_for_tachikoma` command instead of `lock_diff`.
`lock_diff_for_tachikoma` automatically detects and comments on the most recent tachikoma pull request.

#### Command line

```sh
$ lock_diff_for_tachikoma
Usage: lock_diff_for_tachikoma [options]
Require flags
    -r, --repository=REPOSITORY      Like as "user/repository"

Optional flags
        --post-comment=true or false Print result to stdout when false. (default is false)
    -v, --verbose                    Run verbosely
        --version                    Show version
```

```sh
$ lock_diff_for_tachikoma -r "vividmuimui/lock_diff_sample" --post-comment=false
```

#### Ruby

```ruby
require 'lock_diff'
LockDiff.lock_diff_for_tachikoma(repository: "vividmuimui/lock_diff_sample", post_comment: false)
```

## Development

TODO:

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lock_diff. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the LockDiff project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/lock_diff/blob/master/CODE_OF_CONDUCT.md).
