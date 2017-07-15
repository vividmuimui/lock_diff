module LockDiff
  class DiffInfo
    UPGRADE   = 'upgrade'
    DOWNGRADE = 'downgrade'
    DELETE    = 'delete'
    NEW       = 'new'

    def initialize(old_version:, new_version:, package:)
      @old_version = old_version
      @new_version = new_version
      @package = package
    end

    def changed?
      @old_version.different?(@new_version)
    end

    def status
      case
      when @old_version.version && @new_version.version
        if @old_version.version < @new_version.version
          UPGRADE
        else
          DOWNGRADE
        end
      when @old_version.version
        DELETE
      when @new_version.version
        NEW
      end
    end

    def status_emoji
      case status
      when UPGRADE
        ':chart_with_upwards_trend:'
      when DOWNGRADE
        ':chart_with_downwards_trend:'
      when DELETE
        ':x:'
      when NEW
        ':new:'
      end
    end

    def change_log_url
      @change_log_url ||= begin
        ref =
          case status
          when UPGRADE, NEW
            @new_version.ref
          when DOWNGRADE, DELETE
            nil # default branch(master)
          end

        Github::ChangeLogUrlFinder.new(
          repository: @package.repository,
          github_url: @package.github_url,
          ref: ref
        ).call
      end
    end

    def change_log_name
      File.basename(change_log_url)
    end

    def commits_url
      return unless @package.github_url
      old_ref = @old_version.ref
      new_ref = @new_version.ref
      commits_url =
        case status
        when UPGRADE
          "compare/#{old_ref}...#{new_ref}"
        when DOWNGRADE
          "compare/#{new_ref}...#{old_ref}"
        when DELETE
          "commits/#{old_ref}"
        when NEW
          "commits/#{new_ref}"
        end

      "#{@package.github_url}/#{commits_url}"
    end

    def commits_url_text
      case status
      when UPGRADE
        "#{@old_version}...#{@new_version}"
      when DOWNGRADE
        "#{@new_version}...#{@old_version}"
      when DELETE
        "#{@old_version}"
      when NEW
        "#{@new_version}"
      end
    end

  end
end
