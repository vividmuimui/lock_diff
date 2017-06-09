# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bundle_diff_linker/version"

Gem::Specification.new do |spec|
  spec.name          = "bundle_diff_linker"
  spec.version       = BundleDiffLinker::VERSION
  spec.authors       = ["vividmuimui"]
  spec.email         = ["vivid.muimui@gmail.com"]

  spec.summary       = %q{Generate links for Gemfile.lock's diff and post to PullRequest}
  spec.description   = %q{Generate links for Gemfile.lock's diff and post to PullRequest}
  spec.homepage      = "https://github.com/vividmuimui/bundle_diff_linker"
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

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  # あとでけすーーーーーーーーーー
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"

end
