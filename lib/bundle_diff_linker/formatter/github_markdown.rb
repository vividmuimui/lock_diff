module BundleDiffLinker
  module Formatter
    class GithubMarkdown
      def initialize(gem_diffs)
        @gem_diffs = gem_diffs
      end


      def format
        # body = @gem_diffs.map { |gem_diff| format_gem_diff(gem_diff) }

        BundleDiffLinker.logger.info '--start'
        body = @gem_diffs.map do |gem_diff|
          before = Time.now
          row = format_gem_diff(gem_diff)
          after = Time.now
          BundleDiffLinker.logger.info "#{after - before}  -- #{gem_diff.name}"
          row
        end
        BundleDiffLinker.logger.info '--end'
        (headers + body).join("\n")
      end

      private

      def headers
        [
          "| gem_name | diff | change log |",
          "|----------|------|------------|"
        ]
      end

      def format_gem_diff(gem_diff)
        text = []
        text << "[#{gem_diff.name}](#{gem_diff.url})"
        if gem_diff.diff_url
          text << "[#{gem_diff.old_version}...#{gem_diff.new_version}](#{gem_diff.diff_url})"
        else
          text << "#{gem_diff.old_version}...#{gem_diff.new_version}"
        end
        if gem_diff.change_log_url
          text << "[change log](#{gem_diff.change_log_url})"
        else
          text << " | "
        end
        "| #{text.join(' | ')} |"
      end

    end
  end
end
