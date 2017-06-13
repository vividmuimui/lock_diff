module BundleDiffLinker
  module Gem
    class PrLockfile
      def initialize(pull_request)
        @pr = pull_request
      end

      def updated?
        !!path
      end

      def path
        if BundleDiffLinker.cache_response?
          @path ||= @pr.find_content_path("Gemfile.lock")
        else
          @pr.find_content_path("Gemfile.lock")
        end
      end

      def base_file
        if BundleDiffLinker.cache_response?
          @base_file ||= BundleDiffLinker.client.file(@pr.repository, path: path, ref: @pr.base_sha)
        else
          BundleDiffLinker.client.file(@pr.repository, path: path, ref: @pr.base_sha)
        end
      end

      def head_file
        if BundleDiffLinker.cache_response?
          @head_file ||= BundleDiffLinker.client.file(@pr.repository, path: path, ref: @pr.head_sha)
        else
          BundleDiffLinker.client.file(@pr.repository, path: path, ref: @pr.head_sha)
        end
      end

    end
  end
end
