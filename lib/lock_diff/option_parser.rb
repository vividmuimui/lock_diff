require "optparse"

module LockDiff
  class OptionParser
    class << self
      def parse(args, require_flags:)
        new(require_flags).parse(args)
      end
    end

    def initialize(require_flags)
      @require_flags = require_flags
    end

    def parse(args)
      options = {
        post_comment: false
      }
      opt = ::OptionParser.new

      opt.separator("Require flags")
      if @require_flags.include? :repository
        opt.on('-r', '--repository=REPOSITORY', 'Like as "user/repository"') { |v| options[:repository] = v }
      end
      if @require_flags.include? :number
        opt.on('-n', '--number=PULL_REQUEST_NUMBER') { |v| options[:number] = v }
      end

      opt.separator("\nOptional flags")
      opt.on('--post-comment=true or false', 'Print result to stdout when false. (default is false)') { |v| options[:post_comment] = v }
      opt.on("-v", "--verbose", "Run verbosely") { LockDiff.logger.level = :info }
      opt.on("--more-verbose", "Run more verbosely") { LockDiff.logger.level = :debug }
      opt.on_tail("--version", "Show version") do
        $stdout.puts LockDiff::VERSION
        exit
      end
      opt.parse!(args)

      if @require_flags.all? { |flag| options.has_key?(flag) }
        options
      else
        $stdout.puts opt.help
        exit
      end
    end

  end
end