module BundleDiffLinker
  module Github
    class PullRequest
      def initialize(repository:, number:, client: BundleDiffLinker.github_client)
        @repository = repository
        @number = number
        @client = client
      end

      def bundle_updated?
        !!gemfile_lock_path
      end

      def old_gemfile_lock
        file_content(gemfile_lock_path, :base)
      end

      def new_gemfile_lock
        file_content(gemfile_lock_path, :head)
      end

      private

      def pull_request
        @client.pull_request(@repository, @number)
      end

      def files
        @client.pull_request_files(@repository, @number)
      end

      def file_content(path, base_or_head)
        raise unless %i(head base).include? base_or_head.to_sym
        @client.file_content(
          @repository,
          path: path,
          ref: pull_request.send(base_or_head).sha
        )
      end

      def gemfile_lock_path
        files.
          map(&:filename).
          find { |filename| filename.include?("Gemfile.lock") }
      end
    end
  end
end
