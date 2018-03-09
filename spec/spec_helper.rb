$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dotenv'
Dotenv.load

require 'simplecov'
SimpleCov.start

require "shared_contexts"
require 'wax_iiif'

ENV["TEST_INTERNET_CONNECTIVITY"] ||= nil
ENV["SKIP_EXPENSIVE_TESTS"] ||= nil
