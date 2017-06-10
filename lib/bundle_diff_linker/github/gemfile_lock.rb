module BundleDiffLinker
  module Github
    class GemfileLock
      def initialize(pull_request)
        @pull_request = pull_request
        @gemfile_lock_path = fetch_gemfile_lock_path
      end

      def bundle_updated?
        !!gemfile_lock_path
      end

      def old_ver
        @pull_request.file_content(@gemfile_lock_path, :base)
      end

      def new_ver
        @pull_request.file_content(@gemfile_lock_path, :head)
      end

      private

      def fetch_gemfile_lock_path
        @pull_request.files.
          map(&:filename).
          find { |filename| filename.include?("Gemfile.lock") }
      end
    end
  end
end
