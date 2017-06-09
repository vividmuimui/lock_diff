require 'octokit'

module BundleDiffLinker
  module Github
    class Client < Octokit::Client
      def initialize(access_token)
        super(access_token: access_token)
      end
    end
    # class Client
    #   def initialize(access_token)
    #     @octokit = Octokit::Client.new(access_token: access_token)
    #   end

    #   def pull_request_files(repository, pull_request_number)
    #     @octokit.pull_request_files(repository, pull_request_number)
    #   end
    # end
  end
end
