module LockDiff
  module Github
    # wrapper of Github Content
    class Content
      extend Forwardable

      def_delegators :@content, :name, :html_url

      def initialize(content)
        @content = content
      end

      def file?
        @content.type == 'file'
      end

    end
  end
end
