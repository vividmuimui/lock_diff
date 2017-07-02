# LockDiff

[![CircleCI](https://circleci.com/gh/vividmuimui/lock_diff.svg?style=svg)](https://circleci.com/gh/vividmuimui/lock_diff)

This Gem is generate `changelog url`, `github compare link` by lock file of Github pull request. And commant to that pull request.
Like as this.

> https://github.com/vividmuimui/rails_tutorial/pull/26#issuecomment-312491272
> ![image](https://user-images.githubusercontent.com/1803598/27770131-21db6112-5f74-11e7-80ed-28e5793beffc.png)

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

Require `GITHUB_ACCESS_TOKEN` environment.

### Command line

```sh
$ lock_diff
Usage: lock_diff [options]
    -r, --repository=REPOSITORY      required. Like as rails/rails
    -n, --number=PULL_REQUEST_NUMBER required
        --post-comment=true or false dafault=false
```

```sh
$ lock_diff -r "vividmuimui/rails_tutorial" -n 26 --post-comment=false
```

### Ruby

```ruby
require 'lock_diff'
LockDiff.run(repository: "vividmuimui/rails_tutorial", number: 26, post_comment: false)
```

## Development

TODO:

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lock_diff. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the LockDiff project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/lock_diff/blob/master/CODE_OF_CONDUCT.md).
