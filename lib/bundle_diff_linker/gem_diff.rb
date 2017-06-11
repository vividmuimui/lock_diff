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

    # def to_s
    #   text = []
    #   text << "[#{@new_gem.name}](#{@new_gem.url})"
    #   if diff_link
    #     text << "[#{@old_gem.version}...#{@new_gem.version}](#{diff_link})"
    #   else
    #     text << "#{@old_gem.version}...#{@new_gem.version}"
    #   end
    #   if @new_gem.change_log_link
    #     text << "[change log](#{@new_gem.change_log_link})"
    #   end
    #   "| #{text.join(' | ')} |"
    # end

    # def diff_link
    #   return unless @new_gem.github_url
    #   if @new_gem.ref && @old_gem.ref
    #     "#{@new_gem.github_url}/compare/#{@old_gem.ref}...#{@new_gem.ref}"
    #   end
    # end
  end
end
