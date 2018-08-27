require "spec_helper"

module LockDiff::Github
  RSpec.describe RepositoryNameDetector do
    specify do
      expect(RepositoryNameDetector.new("https://github.com/rr/rr").call).to eq 'rr/rr'
      expect(RepositoryNameDetector.new("https://github.com/rr/rr/foo/bar/baz").call).to eq 'rr/rr'
      expect(RepositoryNameDetector.new("https://github.com/rr/rr/foo#readme").call).to eq 'rrg/rr'
      expect(RepositoryNameDetector.new('https://rubygems.org/gems/rr').call).to eq nil
      expect(RepositoryNameDetector.new(nil).call).to eq nil
    end
  end
end
