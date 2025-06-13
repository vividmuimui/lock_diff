# frozen_string_literal: true

require "spec_helper"

module LockDiff
  module Github
    RSpec.describe Directory do
      describe "#change_log_urls?" do
        context "CHANGELOG exists in repository root" do
          specify do
            repository = described_class.new("vcr/vcr", "master")

            ::VCR.use_cassette("vcr") do
              expect(repository.change_log_urls).to eq ["https://github.com/vcr/vcr/blob/master/CHANGELOG.md"]
            end
          end
        end

        context "CHANGELOG does not exist in repository root" do
          specify do
            repository = described_class.new("rails/rails", "master")

            ::VCR.use_cassette("rails") do
              expect(repository.change_log_urls).to eq []
            end
          end
        end

        context "CHANGELOG exists in subdirectory" do
          specify do
            repository = described_class.new("aws/aws-sdk-ruby", "version-3", path: "gems/aws-sdk-s3")

            ::VCR.use_cassette("aws") do
              expect(repository.change_log_urls).to eq ["https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-s3/CHANGELOG.md"]
            end
          end
        end
      end
    end
  end
end
