# frozen_string_literal: true

require 'pathname'

#
# Reads a file and handles reading in chunks
#
class FileReader
  def read_file(log_file)
    raise "File #{log_file} does not exist" unless Pathname.new(log_file).exist?

    log_file_handler = File.open(log_file)
    lines = []
    log_file_handler.each_line { |line| lines << line.strip }
    log_file_handler.close
    lines
  end
end
