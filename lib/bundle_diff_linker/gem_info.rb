module BundleDiffLinker
  class GemInfo
    attr_reader :name

    def initialize(spec)
      @spec = spec
    end

    def name
      @spec.name
    end

    def version
      @spec.version
    end

    def rivision
      @spec.git_version
    end

    def url
      ruby_gem.github_url || ruby_gem.homepage_uri
    end

    def git_tag

    end

    def ruby_gem
      @ruby_gem ||= begin
        BundleDiffLinker.logger.debug("fetch #{name} gem info by rubygems")
        RubyGem.new(name)
      end
    end

  end
end
