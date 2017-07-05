# LockDiff

[![CircleCI](https://circleci.com/gh/vividmuimui/lock_diff.svg?style=svg)](https://circleci.com/gh/vividmuimui/lock_diff)

This gem detects changes to your package manager (e.g. Gemfile) and generates a Markdown-formatted diff including:

* links to the corresponding package's change logs
* Github `...`-delineated diff links for the relevant changes

It also optionally posts the diff as a comment to the pull request responsible for the package update.

Like this.

> https://github.com/vividmuimui/rails_tutorial/pull/26#issuecomment-312491272
> ![image](https://user-images.githubusercontent.com/1803598/27770516-f5774972-5f7a-11e7-87a6-7c3cbf1de745.png)

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
    -r, --repository=REPOSITORY      required. Like as "user/repository"
    -n, --number=PULL_REQUEST_NUMBER required
        --post-comment=true or false (default=false. Print result to stdout when false.)
```

For example, to comment on https://github.com/vividmuimui/rails_tutorial/pull/26#issuecomment-312491272, run this command:

```sh
$ lock_diff -r "vividmuimui/rails_tutorial" -n 26 --post-comment=false
```

### Ruby

```ruby
require 'lock_diff'
LockDiff.run(repository: "vividmuimui/rails_tutorial", number: 26, post_comment: false)
```

### For Tachikoma pull request

When used in conjunction with [tachikoma](https://rubygems.org/gems/tachikoma), use the `lock_diff_for_tachikoma` command instead of `lock_diff`.
`lock_diff_for_tachikoma` automatically detects and comments on the most recent tachikoma pull request.

#### Command line

```sh
$ lock_diff
Usage: lock_diff_for_tachikoma [options]
    -r, --repository=REPOSITORY      required. Like as "user/repository"
        --post-comment=true or false default=false
```

```sh
$ lock_diff_for_tachikoma -r "vividmuimui/rails_tutorial" --post-comment=false
```

#### Ruby

```ruby
require 'lock_diff'
LockDiff.lock_diff_for_tachikoma(repository: "vividmuimui/rails_tutorial", post_comment: false)
```

## Development

TODO:

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lock_diff. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the LockDiff project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/lock_diff/blob/master/CODE_OF_CONDUCT.md).
