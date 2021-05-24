module LockDiff
  class DiffInfo
    extend Forwardable

    UPGRADE   = 'upgrade'
    DOWNGRADE = 'downgrade'
    DELETE    = 'delete'
    NEW       = 'new'

    attr_reader :old_package, :new_package
    def_delegators :package, :name, :repository_url
    def_delegator :package, :url, :package_url

    def initialize(old_package:, new_package:)
      @old_package = old_package
      @new_package = new_package
    end

    def changed?
      @old_package.different?(@new_package)
    end

    def status
      case
      when @old_package.version && @new_package.version
        if @old_package.version <= @new_package.version
          UPGRADE
        else
          DOWNGRADE
        end
      when @old_package.version
        DELETE
      when @new_package.version
        NEW
      end
    end

    def package
      case status
      when UPGRADE, NEW
        @new_package
      when DOWNGRADE, DELETE
        @old_package
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

    def changelogs
      return nil if [DOWNGRADE, DELETE].include?(status)

      Github::ChangelogUrlFinder.new(
        repository: package.repository,
        repository_url: package.repository_url,
        ref: @new_package.ref,
        package_name: package.name
      ).call.map do |url|
        Changelog.new(url)
      end
    end

    def commits_url
      return unless package.repository_url
      old_ref = @old_package.ref
      new_ref = @new_package.ref
      compare_path =
        case status
        when UPGRADE
          "compare/#{old_ref}...#{new_ref}" if old_ref && new_ref
        when DOWNGRADE
          "compare/#{new_ref}...#{old_ref}" if old_ref && new_ref
        when DELETE
          "commits/#{old_ref}" if old_ref
        when NEW
          "commits/#{new_ref}" if new_ref
        end

      "#{package.repository_url}/#{compare_path}" if compare_path
    end

    def commits_url_text
      case status
      when UPGRADE
        "#{@old_package.version_str}...#{@new_package.version_str}"
      when DOWNGRADE
        "#{@new_package.version_str}...#{@old_package.version_str}"
      when DELETE
        "#{@old_package.version_str}"
      when NEW
        "#{@new_package.version_str}"
      end
    end

  end
end
