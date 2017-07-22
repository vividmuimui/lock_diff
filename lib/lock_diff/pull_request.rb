module LockDiff
  class PullRequest
    extend Forwardable

    class << self
      def find_by(repository:, number:)
        LockDiff.config.pr_repository_service.client.pull_request(repository, number)
      rescue => e
        message = "Not found pull request by (repository: #{repository}, number: #{number}, client: #{LockDiff.client.class}). Becase of #{e.inspect}"
        LockDiff.logger.warn(message)
        raise NotFoundPullRequest.new(message)
      end

      def latest_by_tachikoma(repository)
        LockDiff.config.pr_repository_service.client.newer_pull_requests(repository).
          find { |pull_request| pull_request.head_ref.include?("tachikoma") }
      end
    end

  end
end
