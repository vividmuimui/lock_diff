require "spec_helper"

module LockDiff
  module Gem
    RSpec.describe Spec do
      let(:test_data) { TestData::Gem.new }
      let(:spec_with_revision) { Spec.new(test_data.sample_git_source) }
      let(:spec_with_git_tag) { Spec.new(test_data.lazy_specifications.find { |a| a.name == "brakeman" }) }
      let(:spec_without_ref) { Spec.new(test_data.lazy_specifications.find { |a| a.name == "dummy_gem" }) }
      let(:null_spec) { NullSpec.new("dummy") }

      describe '#ref', with_http: true do
        specify do
          expect(Package.new(spec_with_revision).ref).to eq spec_with_revision.revision

          VCR.use_cassette('brakeman') do
            expect(Package.new(spec_with_git_tag).ref).to eq "v3.6.2"
          end

          expect(Package.new(spec_without_ref).ref).to be_nil
        end
      end

      describe '#version_str' do
        specify do
          expect(Package.new(spec_with_revision).version_str).to eq spec_with_revision.revision
          expect(Package.new(spec_with_git_tag).version_str).to eq spec_with_git_tag.version.to_s
          expect(Package.new(spec_without_ref).version_str).to eq spec_without_ref.version.to_s
          expect(Package.new(null_spec).version_str).to eq ""
        end
      end

      describe '#different?' do
        skip
      end

      describe '#repository' do
        specify do
          spec = double(repository_url: 'https://github.com/rr/rr')
          expect(Package.new(spec).repository).to eq 'rr/rr'

          spec = double(repository_url: nil)
          expect(Package.new(spec).repository).to be_nil
        end
      end

    end
  end
end
