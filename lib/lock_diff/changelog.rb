# frozen_string_literal: true

module LockDiff
  class Changelog
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def name
      File.basename(@url)
    end
  end
end
