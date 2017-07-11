module LockDiff
  module Gem
    class Version
      extend Forwardable

      def_delegators :@spec, :revision, :version

      def initialize(gem:, spec:)
        @gem = gem
        @spec = spec
      end

      def ref
        revision || git_tag
      end

      def to_s
        revision || version.to_s
      end

      private

      def git_tag
        return @git_tag if defined? @git_tag
        @git_tag = find_tag(limit: 4, per_page: 50)
      end

      def find_tag(page: 1, limit:, per_page:)
        return nil if page > limit

        version_str = version.to_s
        fetched_tags = LockDiff.client.tag_names(@gem.repository, page: page, per_page: per_page)
        tag = fetched_tags.find do |tag_name|
          tag_name == version_str ||
            tag_name == "v#{version_str}" ||
            tag_name == "#{@gem.name}-#{version_str}"
        end

        if tag
          return tag
        else
          LockDiff.logger.debug { "Not found tag of #{@gem.name}, #{version_str} by page: #{page}, per_page: #{per_page}"}
          unless fetched_tags.count < per_page
            find_tag(page: page + 1, limit: limit, per_page: per_page)
          end
        end
      end

    end
  end
end
