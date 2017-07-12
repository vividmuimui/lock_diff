module LockDiff
  module Formatter
    class GithubMarkdown
      def self.format(diff_infos)
        new(diff_infos).call
      end

      def initialize(diff_infos)
        @diff_infos = diff_infos
      end


      def call
        (headers + body).join("\n")
      end

      private

      def headers
        [
          "| gem_name | diff | change log |",
          "|----------|------|------------|"
        ]
      end

      def body
        @diff_infos.map { |diff_info| DiffFormmater.new(diff_info).call }
      end

      class DiffFormmater
        def initialize(diff_info)
          LockDiff.logger.debug diff_info.name
          @diff_info = diff_info
        end

        def call
          text = []
          text << name
          text << diff_text
          text << change_log
          "| #{text.join(' | ')} |"
        end

        private

        attr_reader :diff_info

        def name
          "[#{diff_info.name}](#{diff_info.url})"
        end

        def diff_text
          if diff_info.compare_url
            "[#{diff_info.old_version}...#{diff_info.new_version}](#{diff_info.compare_url})"
          else
            "#{diff_info.old_version}...#{diff_info.new_version}"
          end
        end

        def change_log
          if diff_info.change_log_url
            "[#{diff_info.change_log_name}](#{diff_info.change_log_url})"
          else
            ""
          end
        end
      end

    end
  end
end
