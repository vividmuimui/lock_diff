module LockDiff
  module Github
    # wrapper of github PullRequest
    class PullRequest
      def initialize(pull_request)
        @pr = pull_request
      end

      def base_sha
        @pr.base.sha
      end

      def head_sha
        @pr.head.sha
      end

      def base_ref
        @pr.base.ref
      end

      def head_ref
        @pr.head.ref
      end

      def number
        @pr.number
      end
    end
  end
end
