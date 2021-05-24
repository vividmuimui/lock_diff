require "bundler/setup"
require "lock_diff"
require "vcr"
Dir[File.expand_path(File.dirname(__FILE__) + "/support/**/*.rb")].each(&method(:require))

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # config.filter_run_excluding with_http: true
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data('<TOKEN>') { ENV.fetch('GITHUB_ACCESS_TOKEN') }
end

LockDiff.logger.level = :debug
