#!/usr/bin/env ruby

# frozen_string_literal: true

$LOAD_PATH << '.'
$LOAD_PATH << './lib'
Dir['lib/monkey_patches/*.rb'].sort.each { |file| require file }

require 'parser_ioc_container'
require 'web_server_parser'
require 'optparser'

log_file, options = CmdOptionParser.parse_options
CmdOptionParser.validate_options log_file, options

wsp = ParserContainer.resolve 'web_server_parser'
logger = ParserContainer.resolve 'logger'
logger.level = options['log-level']

begin
  sorted_visits, sorted_unique_visits = wsp.parse log_file, options
  puts "sorted_visits #{sorted_visits}"
  puts "sorted_unique_visits #{sorted_unique_visits}"
rescue StandardError => e
  logger.error e.message
  logger.debug '----------------------------'
  e.backtrace.each do |traceline|
    logger.debug traceline
  end
  logger.debug '----------------------------'
end
