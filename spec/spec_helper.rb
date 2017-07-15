$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "typical"

require "minitest/around"
require "minitest/autorun"
require "minitest/focus"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
