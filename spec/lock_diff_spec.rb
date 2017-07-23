require "spec_helper"

RSpec.describe LockDiff do
  it "has a version number" do
    expect(LockDiff::VERSION).not_to be nil
  end

  it "has initialized config" do
    expect(LockDiff.config).to be_a LockDiff::Config
    expect(LockDiff.config.pr_repository_service).to eq LockDiff::Github
    expect(LockDiff.config.formatter).to eq LockDiff::Formatter::GithubMarkdown
    expect(LockDiff.config.strategy).to eq LockDiff::Gem
    expect(LockDiff.logger).to be_a Logger
  end
end
