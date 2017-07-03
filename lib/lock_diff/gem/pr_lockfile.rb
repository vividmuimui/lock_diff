module LockDiff
  module Gem
    class PrLockfile
      def initialize(pull_request)
        @pr = pull_request
      end

      def changed?
        !!path
      end

      def path
        @path ||= @pr.find_content_path("Gemfile.lock")
      end

      def base_file
        @base_file ||= LockDiff.client.file(@pr.repository, path: path, ref: @pr.base_sha)
      end

      def head_file
        @head_file ||= LockDiff.client.file(@pr.repository, path: path, ref: @pr.head_sha)
      end

    end
  end
end
