require 'octokit'

module BundleDiffLinker
  module Github
    class Client < SimpleDelegator
      def initialize(access_token)
        octokit = Octokit::Client.new(access_token: access_token)
        super(octokit)
      end

      def file(repository, path:, ref:)
        content = contents(repository, path: path, ref: ref)
        Base64.decode64(content.content)
      end

      def pull_request(repository, number)
        Github::PullRequest.new(super(repository, number))
      end

      def pull_request_content(repository, number, file_name)
        content = pull_request_files(repository, number).
          find { |file| file.filename.include?(file_name) }
        if content
          Github::PullRequestContent.new(content)
        end
      end

    end
  end
end
