module BundleDiffLinker
  module Github
    class PullRequestContent
      def initialize(content)
        @content = content
      end

      def path
        @content.filename
      end
    end
  end
end
