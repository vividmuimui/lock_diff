module BundleDiffLinker
  module Formatter
    class GithubMarkdown
      def initialize(diffs)
        @diffs = diffs
      end


      def format
        body = @diffs.map { |diff| format_gem_diff(diff) }
        (headers + body).join("\n")
      end

      private

      def headers
        [
          "| gem_name | diff | change log |",
          "|----------|------|------------|"
        ]
      end

      def format_gem_diff(diff)
        BundleDiffLinker.logger.debug diff.name
        text = []
        text << "[#{diff.name}](#{diff.url})"
        if diff.diff_url
          text << "[#{diff.old_version}...#{diff.new_version}](#{diff.diff_url})"
        else
          text << "#{diff.old_version}...#{diff.new_version}"
        end
        if diff.change_log_url
          text << "[change log](#{diff.change_log_url})"
        else
          text << " | "
        end
        "| #{text.join(' | ')} |"
      end

    end
  end
end
