module LockDiff
  class LockfileComparator
    class NotChangedLockfile < StandardError; end

    class << self
      def compare_by(pull_request)
        file_path = pull_request.find_content_path(lockfile_name)
        raise NotChangedLockfile if file_path.nil?

        LockDiff.config.strategy.lockfile_comparator.new(
          old_lockfile: pull_request.base_file(file_path),
          new_lockfile: pull_request.head_file(file_path)
        ).call
      end

      def lockfile_name
        LockDiff.config.strategy.lockfile_name
      end
    end
  end
end
