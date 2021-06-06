# frozen_string_literal: true

require 'dry-container'
require 'dry-auto_inject'
require 'logger'
#
# Inversion of Control registery
#
class ParserContainer
  extend Dry::Container::Mixin

  register 'web_server_parser' do
    WebServerParser.new
  end
  register 'file_reader' do
    FileReader.new
  end

  register 'page_tracker' do
    PageTracker.new
  end

  register 'logger' do
    Logger.new $stdout
  end
end

Import = Dry::AutoInject(ParserContainer).args
