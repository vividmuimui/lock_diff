module LockDiff
  module Github
    class TagFinder
      def initialize(repository:, package_name:, version_str:)
        @repository = repository
        @package_name = package_name
        @version_str = version_str
      end

      def call
        find_tag(limit: 4, per_page: 50)
      end

      private

      def find_tag(page: 1, limit:, per_page:)
        return nil if page > limit

        fetched_tags = LockDiff.client.tag_names(@repository, page: page, per_page: per_page)
        tag = fetched_tags.find do |tag_name|
          tag_name == @version_str ||
            tag_name == "v#{@version_str}" ||
            tag_name == "#{@package_name}-#{@version_str}"
        end

        if tag
          return tag
        else
          LockDiff.logger.debug { "Not found tag of #{@package_name}, #{@version_str} by page: #{page}, per_page: #{per_page}"}
          unless fetched_tags.count < per_page
            find_tag(page: page + 1, limit: limit, per_page: per_page)
          end
        end
      end

    end
  end
end
