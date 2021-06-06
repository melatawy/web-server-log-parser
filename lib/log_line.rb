# frozen_string_literal: true

autoload :LogLineParsers, 'parsers'

#
# Responsible for parsing log lines given a set of options
#
class LogLine
  include LogLineParsers

  def self.parse(log_line, options)
    parser = LogLineParsers.get_parser options[:parser]
    parser.call log_line, options
  end
end
