# frozen_string_literal: true

require "spec_helper"

RSpec.describe LockDiff do
  it "has a version number" do
    expect(LockDiff::VERSION).not_to be_nil
  end

  it "has initialized config" do
    expect(described_class.config).to be_a LockDiff::Config
    expect(described_class.config.pr_repository_service).to eq LockDiff::Github
    expect(described_class.config.formatter).to eq LockDiff::Formatter::GithubMarkdown
    expect(described_class.config.strategy).to eq LockDiff::Gem
    expect(described_class.logger).to be_a Logger
  end
end
