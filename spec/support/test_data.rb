module TestData
  class Gem
    FILES = {
      default: File.read(File.expand_path(File.dirname(__FILE__) + "/../test_data/lockfile/gemfile_lock/Gemfile.lock.base")),
      base: File.read(File.expand_path(File.dirname(__FILE__) + "/../test_data/lockfile/gemfile_lock/Gemfile.lock.base")),
      head: File.read(File.expand_path(File.dirname(__FILE__) + "/../test_data/lockfile/gemfile_lock/Gemfile.lock.head"))
    }

    attr_reader :lockfile

    def initialize(lockfile = FILES[:default])
      @lockfile = lockfile
    end

    def lockfile_parser
      Bundler::LockfileParser.new(lockfile)
    end

    def lazy_specifications
      lockfile_parser.specs
    end

    def sample_git_source
      lazy_specifications.select { |spec| spec.source.class == Bundler::Source::Git }.sample
    end

    def sample_rubygems_source
      lazy_specifications.select { |spec| spec.source.class == Bundler::Source::Rubygems }.sample
    end

    def sample_path_source
      lazy_specifications.select { |spec| spec.source.class == Bundler::Source::Path }.sample
    end
  end
end
