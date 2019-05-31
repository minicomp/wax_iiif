$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dotenv'
require 'simplecov'
Dotenv.load

# use codecov + add requirements
SimpleCov.start do
  add_filter 'spec'
end

require 'shared_contexts'
require 'wax_iiif'

ENV['TEST_INTERNET_CONNECTIVITY'] ||= nil
ENV['SKIP_EXPENSIVE_TESTS'] ||= nil
