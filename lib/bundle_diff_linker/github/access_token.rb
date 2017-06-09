require 'octokit'

module BundleDiffLinker
  module Github
    class AccessToken < ::String
      def initialize(string = nil)
        string ||= ENV.fetch('GITHUB_ACCESS_TOKEN')
        super(string)
      end
    end
  end
end
