# frozen_string_literal: true

require "spec_helper"

module LockDiff
  module Github
    RSpec.describe RepositoryNameDetector do
      specify do
        expect(described_class.new("https://github.com/rr/rr").call).to eq "rr/rr"
        expect(described_class.new("https://github.com/rr/rr/foo/bar/baz").call).to eq "rr/rr"
        expect(described_class.new("https://github.com/rr/rr/foo#readme").call).to eq "rr/rr"
        expect(described_class.new("https://rubygems.org/gems/rr").call).to be_nil
        expect(described_class.new(nil).call).to be_nil
      end
    end
  end
end
