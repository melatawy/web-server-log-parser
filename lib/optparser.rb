# frozen_string_literal: true

require 'optparse'
autoload :LogLineParsers, 'parsers'

#
# Responsible for parsing command line options
#
module CmdOptionParser
  def self.parse_options
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: ./parser.rb PATH_TO_LOG_FILE [options]'

      specify_parser opts, options
      specify_skip_malformed_entries opts, options
      specify_validate_ip opts, options
      specify_log_level opts, options

      defaults options
    end.parse!

    [ARGV[0], options]
  end

  def self.validate_options(log_file, _options)
    abort 'Missing log file' if log_file.nil?
  end

  def self.defaults(options)
    options[:parser] ||= LogLineParsers::URL_AND_IP_PARSER
    options[:validate_ip] ||= false
    options[:skip] ||= false
    options['log-level'] ||= Logger::WARN
  end

  def self.specify_parser(opts, options)
    opts.on('-p', '--parser PARSER', LogLineParsers::AVAILABLE_PARSERS,
            'Parser to be used') do |v|
      options[:parser] = v
    end
  end

  def self.specify_skip_malformed_entries(opts, options)
    opts.on('-s', '--skip', 'Skips malformed entries') do |v|
      options[:skip] = v
    end
  end

  def self.specify_validate_ip(opts, options)
    opts.on('-i', '--validate-ip', 'Validates ip') do |v|
      options[:validate_ip] = v
    end
  end

  def self.specify_log_level(opts, options)
    log_levels = [
        'unknown',
        'fatal',
        'error',
        'warn',
        'info',
        'debug',
    ]
    opts.on('-l', '--log-level LOG_LEVEL', log_levels, 
            'Specify Log Level') do |v|
      options['log-level'] = v.downcase
    end
  end
end
