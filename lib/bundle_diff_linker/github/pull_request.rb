require 'octokit'

module BundleDiffLinker
  module Github
    class PullRequest
      def initialize(client:, repository:, number:)
        @client = client
        @repository = repository
        @number = number
      end

      def bundle_updated?
        @client.pull_request_files(@repository, @number).
          map(&:filename).
          any? { |filename| filename.include?("Gemfile.lock") }
      end

      def lock_files

      end
    end
  end
end
