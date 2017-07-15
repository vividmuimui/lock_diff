module LockDiff
  module Gem
    class RubyGemRepository
      class << self
        def find(name)
          ruby_gem = repository[name]
          return ruby_gem if ruby_gem
          repository[name] = RubyGem.new(name)
        end

        def repository
          @repository ||= {}
        end

        def clear
          @repository = {}
        end
      end

    end

  end
end
