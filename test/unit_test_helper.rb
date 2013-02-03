$:.push File.join(File.dirname(__FILE__),'..','app')

require 'rr'
require 'minitest/spec'
require 'minitest/autorun'
require 'ostruct'

class MiniTest::Unit::TestCase
  include RR::Adapters::MiniTest
end
