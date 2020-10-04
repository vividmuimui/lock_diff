# LockDiff

[![Gem Version](https://badge.fury.io/rb/lock_diff.svg)](https://badge.fury.io/rb/lock_diff)
[![Build Status](https://travis-ci.org/vividmuimui/lock_diff.svg?branch=master)](https://travis-ci.org/vividmuimui/lock_diff)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d05b439bc5064e30ad84ecfa8e57b448)](https://www.codacy.com/app/vividmuimui/lock_diff?utm_source=github.com&utm_medium=referral&utm_content=vividmuimui/lock_diff&utm_campaign=badger)
[![Code Climate](https://codeclimate.com/github/vividmuimui/lock_diff/badges/gpa.svg)](https://codeclimate.com/github/vividmuimui/lock_diff)

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

Bug reports and pull requests are welcome on GitHub at https://github.com/vividmuimui/lock_diff. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

### Original

Most of the source code in this repository is by https://github.com/kyanny/compare_linker.

```
Copyright (c) 2014 Kensuke Nagae

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```


## Code of Conduct

Everyone interacting in the LockDiff project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/vividmuimui/lock_diff/blob/master/CODE_OF_CONDUCT.md).
