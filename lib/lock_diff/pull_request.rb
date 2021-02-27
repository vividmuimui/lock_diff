module LockDiff
  class PullRequest
    extend Forwardable
    class NotFoundPullRequest < StandardError; end

    class << self
      def find_by(repository:, number:)
        client.pull_request(repository, number)
      rescue => e
        message = "Not found pull request by (repository: #{repository}, number: #{number}, client: #{client.class}). Becase of #{e.inspect}"
        LockDiff.logger.warn(message)
        raise NotFoundPullRequest.new(message)
      end

      def latest_by_tachikoma(repository)
        client.newer_pull_requests(repository).find do |pull_request|
          branch = pull_request.head_ref
          branch.include?("tachikoma") || branch.include?("bundle-update")
        end
      end

      private

      def client
        LockDiff.config.pr_repository_service.client
      end
    end

  end
end
