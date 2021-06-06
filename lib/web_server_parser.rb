# frozen_string_literal: true

autoload :FileReader, 'file_reader'
autoload :PageTracker, 'page_tracker'
autoload :LogLine, 'log_line'

#
# Main parser entry point
#
class WebServerParser
  include Import['file_reader', 'page_tracker']

  attr_reader :file_reader, :page_tracker

  def parse(log_file, options)
    lines = file_reader.read_file log_file

    parsed_lines = lines.map { |line| LogLine.parse(line, options) }.compact
    page_tracker.add_all parsed_lines
    sorted_visits = page_tracker.visits
    sorted_unique_visits = page_tracker.unique_visits

    [sorted_visits, sorted_unique_visits]
  end
end
