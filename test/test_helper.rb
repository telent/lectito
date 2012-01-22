ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/spec'
require 'rails/test_help'
require 'ostruct'
require 'rr'

class MiniTest::Unit::TestCase
  include RR::Adapters::MiniTest
end
