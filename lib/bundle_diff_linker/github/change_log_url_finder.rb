module BundleDiffLinker
  module Github
    class ChangeLogUrlFinder
      def initialize(gem_info)
        @gem_info = gem_info
      end

      def find
        return unless @gem_info.repository
        find_file_url || find_release_url
      end

      private

      def find_file_url
        contents = client.contents(@gem_info.repository)
        contents.select { |content| content.type == "file" }.
          find { |content|
            change_file_names.find do |candidate|
              content.name.downcase.start_with? candidate
            end
          }&.html_url
      end

      def find_release_url
        unless client.releases(@gem_info.repository).empty?
          @gem_info.github_url + "/releases"
        end
      end

      def client
        BundleDiffLinker.github_client
      end

      def change_file_names
        %w(
          changelog
          change_log
          changes
          history
          releases
          release_note
          news
        )
      end
    end
  end
end
