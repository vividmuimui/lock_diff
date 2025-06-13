# frozen_string_literal: true

require "spec_helper"

module LockDiff
  module Github
    RSpec.describe UrlDetector, :with_http do
      specify do
        urls = [
          "https://github.com/rr/rr",
          "https://rr.github.io/rr/",
          "http://github.com/rr/rr",
          "https://github.com/rr/rr.git",
          "https://github.com/rr/rr/foo/bar/baz"
        ]
        VCR.use_cassette("rr") do
          urls.each do |url|
            expect(described_class.new(url).call).to eq "https://github.com/rr/rr"
          end
        end
      end

      specify do
        urls = [
          "http://example.com/dummy",
          "https://github.com/rr/rr"
        ]
        expect(described_class.new(urls).call).to eq "https://github.com/rr/rr"
      end
    end
  end
end
