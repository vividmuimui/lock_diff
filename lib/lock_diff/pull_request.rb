module LockDiff
  class PullRequest
    extend Forwardable

    class << self
      class NotChangedLockfile < StandardError; end

      def find_by(repository:, number:)
        client.pull_request(repository, number)
      rescue => e
        message = "Not found pull request by (repository: #{repository}, number: #{number}, client: #{LockDiff.client.class}). Becase of #{e.inspect}"
        LockDiff.logger.warn(message)
        raise NotFoundPullRequest.new(message)
      end

      def latest_by_tachikoma(repository)
        client.newer_pull_requests(repository).
          find { |pull_request| pull_request.head_ref.include?("tachikoma") }
      end

      private

      def client
        LockDiff.config.pr_repository_service.client
      end
    end

  end
end
