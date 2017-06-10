require 'octokit'

module BundleDiffLinker
  module Github
    class Client < SimpleDelegator
      def initialize(access_token)
        octokit = Octokit::Client.new(access_token: access_token)
        super(octokit)
      end

      def file_content(repository, path:, ref:)
        content = contents(repository, path: path, ref: ref)
        Base64.decode64(content.content)
      end
    end
  end
end
