# frozen_string_literal: true

module LockDiff
  module Github
    class RepositoryNameDetector
      REGEXP = %r{github\.com[/:](.*?)(?:\.git)?\z}.freeze

      def initialize(url)
        @url = url
      end

      def call
        return unless @url

        path = @url.match(REGEXP).to_a.last&.split("#")&.first
        return unless path

        repository_name = path.split("/").first(2).join("/")
        repository_name if repository_name.match?(%r{.+/.+})
      end
    end
  end
end
