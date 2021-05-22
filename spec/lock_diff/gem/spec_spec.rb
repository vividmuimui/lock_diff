require "spec_helper"

module LockDiff
  module Gem
    RSpec.describe Spec do
      let(:test_data) { TestData::Gem.new }

      describe '.new' do
        it 'returns RubyGemSpec if source is rubygems' do
          lazy_specification = test_data.sample_rubygems_source
          expect(Spec.new(lazy_specification)).to be_a Spec::RubyGemSpec
        end

        it 'returns RubyGemSpec if source is git' do
          lazy_specification = test_data.sample_git_source
          expect(Spec.new(lazy_specification)).to be_a Spec::GitSpec
        end

        it 'returns RubyGemSpec if source is path' do
          lazy_specification = test_data.sample_path_source
          expect(Spec.new(lazy_specification)).to be_a Spec::PathSpec
        end

        it 'raises error if unknown source' do
          lazy_specification = double(source: :unknown, name: :unknown)
          expect { Spec.new(lazy_specification)}.to raise_error Spec::UnSupportSource
        end
      end

      describe '.parse' do
        let(:lockfile) { test_data.lockfile }
        subject { Spec.parse(lockfile) }
        it { is_expected.to all(be_a Spec::Base) }
      end

      shared_examples_for 'Gem::Spec' do
        specify do
          expect(instance).to respond_to(
            *%w(revision to_package repository_url ruby_gem_url name version)
          )
        end

        specify do
          expect(instance.version).to be_a(::Gem::Version).or(be_nil)
          expect(instance.to_package).to be_a Gem::Package
        end
      end

      describe 'RubyGemSpec class' do
        let(:lazy_specification) { test_data.sample_git_source }
        let(:instance) { Spec::RubyGemSpec.new(lazy_specification) }

        it_behaves_like 'Gem::Spec'

        describe '#repository_url', with_http: true do
          specify do
            VCR.use_cassette('github.com') do
              expect(instance.repository_url).to be_start_with 'https://github.com'
            end
          end
        end

        describe '#ruby_gem_url', with_http: true do
          specify do
            VCR.use_cassette('rubygems.org') do
              expect(instance.ruby_gem_url).to be_start_with 'https://rubygems.org/gems/'
            end
          end
        end
      end

      describe 'GitSpec class' do
        let(:lazy_specification) { test_data.sample_git_source }
        let(:instance) { Spec::GitSpec.new(lazy_specification) }

        it_behaves_like 'Gem::Spec'

        describe '#revision' do
          specify { expect(instance.revision).to eq lazy_specification.git_version.strip }
        end

        describe '#repository_url', with_http: true do
          specify { expect(instance.repository_url).to be_start_with "https://github.com/" }
        end
      end

      describe 'PathSpec class' do
        it_behaves_like 'Gem::Spec' do
          let(:instance) { Spec::PathSpec.new(test_data.sample_path_source) }
        end
      end

      describe 'NullSpec class' do
        it_behaves_like 'Gem::Spec' do
          let(:instance) { NullSpec.new('dummy') }
        end
      end
    end
  end
end
