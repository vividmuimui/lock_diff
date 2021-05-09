require "spec_helper"

module LockDiff::Github
  RSpec.describe Directory do
    describe '#change_log_urls?' do
      context 'CHANGELOG exists in repository root' do
        specify do
          repository = Directory.new('vcr/vcr', 'master')

          ::VCR.use_cassette('vcr') do
            expect(repository.change_log_urls).to eq ['https://github.com/vcr/vcr/blob/master/CHANGELOG.md']
          end
        end
      end
    end
  end
end
