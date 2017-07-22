module LockDiff
  module Github
    class PrLockfile
      def initialize(pull_request, lockfile_name)
        @pr = pull_request
        @lockfile_name = lockfile_name
      end

      def changed?
        !!path
      end

      def path
        @path ||= @pr.find_content_path(@lockfile_name)
      end

      def base_file
        @base_file ||= Github.client.file(@pr.repository, path: path, ref: @pr.base_sha)
      end

      def head_file
        @head_file ||= Github.client.file(@pr.repository, path: path, ref: @pr.head_sha)
      end

    end
  end
end
