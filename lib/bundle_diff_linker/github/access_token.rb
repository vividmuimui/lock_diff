require 'octokit'

module BundleDiffLinker
  module Github
    class AccessToken < ::String
      def initialize(token = nil)
        super(token || ENV.fetch('GITHUB_ACCESS_TOKEN'))
      end
    end
  end
end
