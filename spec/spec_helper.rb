# frozen_string_literal: true

require 'simplecov'

SimpleCov.start

Dir['./lib/monkey_patches/*.rb'].sort.each { |file| require file }
