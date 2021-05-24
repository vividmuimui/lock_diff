module LockDiff
  module Github
    # wrapper of Github Content
    class Content
      extend Forwardable

      def_delegators :@content, :name, :html_url

      CHANGE_LOG_CANDIDATES = %w[
        changelog
        changes
        history
        releases
        releasenote
        news
      ].freeze

      def initialize(content)
        @content = content
      end

      def change_log?
        file? && CHANGE_LOG_CANDIDATES.any? do |candidate|
          normalized_name.start_with?(candidate)
        end
      end

      private

      def normalized_name
        @normalized_name ||= name.downcase.delete('_')
      end

      def file?
        @content.type == 'file'
      end
    end
  end
end
