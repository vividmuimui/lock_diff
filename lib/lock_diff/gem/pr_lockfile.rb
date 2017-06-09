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
        @pr.find_content_path("Gemfile.lock")
      end
      memoize :path

      def base_file
        LockDiff.client.file(@pr.repository, path: path, ref: @pr.base_sha)
      end
      memoize :base_file

      def head_file
        LockDiff.client.file(@pr.repository, path: path, ref: @pr.head_sha)
      end
      memoize :head_file

    end
  end
end
