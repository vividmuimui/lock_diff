require 'octokit'

module BundleDiffLinker
  module Github
    # wrapper of Octokit::Client
    class Client
      def initialize(access_token)
        @client = Octokit::Client.new(access_token: access_token)
      end

      def file(repository, path:, ref:)
        content = @client.contents(repository, path: path, ref: ref)
        Base64.decode64(content.content)
      end

      def pull_request(repository, number)
        Github::PullRequest.new(@client.pull_request(repository, number))
      end

      def pull_request_content(repository, number, file_name)
        content = @client.pull_request_files(repository, number).
          find { |file| file.filename.include?(file_name) }
        content&.filename
      end

      def exist_releases?(repository)
        return false unless repository
        @client.releases(repository).empty?
      end

      def contents(repository)
        return [] unless repository
        @client.contents(repository).map do |content|
          Content.new(content)
        end
      end

      def tag_names(repository)
        return [] unless repository
        @client.tags(repository).map(&:name)
      end

    end
  end
end
