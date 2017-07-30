require "spec_helper"

module LockDiff
  RSpec.describe DiffInfo do
    describe '#status' do
      class DummySpec
        attr_reader :name, :revision, :version, :repository_url, :ruby_gem_url
        def initialize(name: 'dummy', revision: nil, version: "1.0.0", repository_url: nil, ruby_gem_url: nil)
          @name = name
          @revision = revision
          @version = ::Gem::Version.new(version)
          @repository_url = repository_url || 'https://github.com/dummy/dummy'
          @ruby_gem_url = ruby_gem_url || 'https://rubygems.org/gems/dummy'
        end

        def to_package
          Gem::Package.new(self)
        end
      end

      it 'returns upgrade if old version < new version' do
        old_package = DummySpec.new(version: "1.0.0").to_package
        new_package = DummySpec.new(version: "1.0.1").to_package
        instance = DiffInfo.new(old_package: old_package, new_package: new_package)
        expect(instance.status).to eq DiffInfo::UPGRADE
      end

      it 'returns upgrade if revision updated and version is same' do
        old_package = DummySpec.new(version: "1.0.0", revision: "123456").to_package
        new_package = DummySpec.new(version: "1.0.0", revision: "abcdef").to_package
        instance = DiffInfo.new(old_package: old_package, new_package: new_package)
        expect(instance.status).to eq DiffInfo::UPGRADE
      end

      it 'returns downgrade if old version > new version' do
        old_package = DummySpec.new(version: "1.0.1").to_package
        new_package = DummySpec.new(version: "1.0.0").to_package
        instance = DiffInfo.new(old_package: old_package, new_package: new_package)
        expect(instance.status).to eq DiffInfo::DOWNGRADE
      end

      it 'returns delete if new package is null' do
        old_package = DummySpec.new.to_package
        new_package = Gem::NullSpec.new('dummy').to_package
        instance = DiffInfo.new(old_package: old_package, new_package: new_package)
        expect(instance.status).to eq DiffInfo::DELETE
      end

      it 'returns new if old package is null' do
        old_package = Gem::NullSpec.new('dummy').to_package
        new_package = DummySpec.new.to_package
        instance = DiffInfo.new(old_package: old_package, new_package: new_package)
        expect(instance.status).to eq DiffInfo::NEW
      end

    end

  end
end
