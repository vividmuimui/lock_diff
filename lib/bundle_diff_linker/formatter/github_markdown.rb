module BundleDiffLinker
  module Formatter
    class GithubMarkdown
      def initialize(gem_diffs)
        @gem_diffs = gem_diffs
      end


      def format
        (headers + @gem_diffs.map { |gem_diff| format_gem_diff(gem_diff) }).join("\n")
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
        text << "[#{gem_diff.new_gem.name}](#{gem_diff.new_gem.url})"
        if diff_link(gem_diff)
          text << "[#{gem_diff.old_gem.version}...#{gem_diff.new_gem.version}](#{diff_link(gem_diff)})"
        else
          text << "#{gem_diff.old_gem.version}...#{gem_diff.new_gem.version}"
        end
        if gem_diff.new_gem.change_log_link
          text << "[change log](#{gem_diff.new_gem.change_log_link})"
        else
          text << " | "
        end
        "| #{text.join(' | ')} |"
      end

      def diff_link(gem_diff)
        return unless gem_diff.new_gem.github_url && gem_diff.new_gem.ref && gem_diff.old_gem.ref
        "#{gem_diff.new_gem.github_url}/compare/#{gem_diff.old_gem.ref}...#{gem_diff.new_gem.ref}"
      end

    end
  end
end
