require "spec_helper"

module LockDiff::Github
  RSpec.describe Content do
    describe '#change_log?' do
      specify do
        change_log = Content.new OpenStruct.new(type: 'file', name: 'CHANGELOG.md')
        release_note = Content.new OpenStruct.new(type: 'file', name: 'RELEASE_NOTE.md')
        gemfile = Content.new OpenStruct.new(type: 'file', name: 'Gemfile')
        directory = Content.new OpenStruct.new(type: 'dir', name: 'app')

        expect(change_log).to be_change_log
        expect(release_note).to be_change_log
        expect(gemfile).not_to be_change_log
        expect(directory).not_to be_change_log
      end
    end
  end
end
