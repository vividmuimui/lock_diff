# frozen_string_literal: true

require "spec_helper"

module LockDiff
  module Github
    RSpec.describe Content do
      describe "#change_log?" do
        specify do
          change_log = described_class.new OpenStruct.new(type: "file", name: "CHANGELOG.md")
          release_note = described_class.new OpenStruct.new(type: "file", name: "RELEASE_NOTE.md")
          gemfile = described_class.new OpenStruct.new(type: "file", name: "Gemfile")
          directory = described_class.new OpenStruct.new(type: "dir", name: "app")

          expect(change_log).to be_change_log
          expect(release_note).to be_change_log
          expect(gemfile).not_to be_change_log
          expect(directory).not_to be_change_log
        end
      end
    end
  end
end
