module BundleDiffLinker
  class GemDiff
    attr_reader :old_gem, :new_gem

    def initialize(old_gem:, new_gem:)
      @old_gem = old_gem
      @new_gem = new_gem
    end

    def difference?
      @old_gem.rivision != @new_gem.rivision ||
        @old_gem.version != @new_gem.version
    end
  end
end
