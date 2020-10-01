# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lock_diff/version"

Gem::Specification.new do |spec|
  spec.name          = "lock_diff"
  spec.version       = LockDiff::VERSION
  spec.authors       = ["vividmuimui"]
  spec.email         = ["vivid.muimui@gmail.com"]

  spec.summary       = %q{This gem detects changes to your package manager (e.g. Gemfile) and generates a Markdown-formatted diff.}
  spec.description   = %q{This gem detects changes to your package manager (e.g. Gemfile) and generates a Markdown-formatted diff.}
  # spec.homepage      = "https://github.com/vividmuimui/lock_diff"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.4.0"

  spec.add_dependency "octokit", "~> 4.0"
  spec.add_dependency "httpclient"

  spec.add_development_dependency "bundler", "> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "codacy-coverage"
end
