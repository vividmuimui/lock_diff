module BundleDiffLinker
  class GemInfo
    attr_reader :name

    def initialize(spec)
      @spec = spec
    end

    def name
      @spec.name
    end

    # versionに依存するもの
    def version
      @spec.version.to_s
    end

    def ref
      git_tag || rivision
    end

    def rivision
      @spec.git_version
    end

    def git_tag
      @git_tag ||= BundleDiffLinker::Github::TagFinder.new(self).find
    end
    # -----------

    def url
      ruby_gem.github_url || ruby_gem.homepage_uri
    end

    def github_url
      ruby_gem.github_url
    end

    def change_log_link
      Github::ChangeLogUrlFinder.new(self).find
    end

    REGEXP = /github\.com\/([^\/]+)\/([^\/]+)/
    def repository
      Github::RepositoryNameDetector.new(ruby_gem.github_url).detect
    end

    def ruby_gem
      @ruby_gem ||= RubyGem.new(name)
    end
  end
end
