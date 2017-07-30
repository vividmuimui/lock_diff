require "spec_helper"

module LockDiff::Github
  RSpec.describe TagFinder, with_http: true do
    [
      {
        repository: "presidentbeef/brakeman",
        package_name: "brakeman",
        version: ::Gem::Version.new("3.7.0"),
        expected: 'v3.7.0'
      },
      {
        repository: "sporkmonger/addressable",
        package_name: "addressable",
        version: ::Gem::Version.new("2.4.0"),
        expected: 'addressable-2.4.0'
      },
      {
        repository: "rack/rack",
        package_name: "rack",
        version: ::Gem::Version.new("2.0.1"),
        expected: '2.0.1'
      },
      {
        repository: "ckruse/CFPropertyList",
        package_name: "CFPropertyList",
        version: ::Gem::Version.new("2.2.8"),
        expected: 'cfpropertylist-2.2.8'
      },
      {
        repository: "vividmuimui/lock_diff",
        package_name: "lock_diff",
        version: ::Gem::Version.new("0.3.1.pre"),
        expected: 'v0.3.1.pre'
      },
    ].each do |params|
      specify do
        tag = TagFinder.new(repository: params[:repository], package_name: params[:package_name], version: params[:version]).call
        expect(tag).to eq params[:expected]
      end
    end
  end
end
