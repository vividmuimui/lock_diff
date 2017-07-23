module LockDiff
  module Github
    class TagFinder
      def initialize(repository:, package_name:, version:)
        @repository = repository
        @package_name = package_name
        @version_str = version.to_s
      end

      def call
        find_tag(limit: 4, per_page: 50)
      end

      private

      def find_tag(page: 1, limit:, per_page:)
        return nil if page > limit

        fetched_tags = Github.client.tag_names(@repository, page: page, per_page: per_page)
        tag = fetched_tags.find { |tag_name| match_rule?(tag_name) }

        if tag
          return tag
        else
          LockDiff.logger.debug { "Not found tag of #{@package_name}, #{@version_str} by page: #{page}, per_page: #{per_page}"}
          unless fetched_tags.count < per_page
            find_tag(page: page + 1, limit: limit, per_page: per_page)
          end
        end
      end

      def match_rule?(tag_name)
        [
          @version_str,
          "v#{@version_str}",
          "#{@package_name}-#{@version_str}",
          "#{@package_name.downcase}-#{@version_str}"
        ].include?(tag_name)
      end
    end
  end
end
