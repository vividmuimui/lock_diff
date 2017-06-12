module BundleDiffLinker
  class GemfileLockComparator
    def self.by(pr_gemfile_lock)
      new(
        old_ver: pr_gemfile_lock.base_file,
        new_ver: pr_gemfile_lock.head_file
      )
    end

    def initialize(old_ver:, new_ver:)
      @old_ver = old_ver
      @new_ver = new_ver
    end

    def compare
      old_specs_by_name = Bundler::LockfileParser.new(@old_ver).specs.group_by(&:name)
      Bundler::LockfileParser.new(@new_ver).specs.map do |new_spec|
        old_spec = old_specs_by_name[new_spec.name]&.first
        next unless old_spec

        GemDiff.new(old_gem: GemInfo.new(old_spec), new_gem: GemInfo.new(new_spec))
      end.compact.select(&:difference?)
    end

  end
end
