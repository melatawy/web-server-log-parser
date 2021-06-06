# frozen_string_literal: true

#
# Provides actual log line parser and an extension point for other formats
#
module LogLineParsers
  URL_AND_IP_PARSER = :url_and_ip
  AVAILABLE_PARSERS = [
    URL_AND_IP_PARSER
  ].freeze

  def self.get_parser(parser)
    case parser
    when :url_and_ip
      url_and_ip_parser
    else
      raise 'Unsupported Parser'
    end
  end

  def self.url_and_ip_parser
    proc do |log_line, options|
      segments = log_line.split(' ')

      # Should be 2 segments, url and IP. Optionally validating ip
      is_valid = validate_log_line segments, validate_ip: options[:validate_ip]
      unless is_valid || options[:skip]
        raise "Malformated logline found #{log_line}"
      end

      { url: segments[0], ip: segments[1] } if is_valid
    end
  end

  def self.validate_log_line(line_segments, validate_ip: false)
    return false unless line_segments.count == 2
    return false if validate_ip && !valid_ip?(line_segments[1])

    true
  end

  def self.valid_ip?(ip)
    ip_segments = ip.split '.'
    ip_segments.all? do |segment|
      segment.integer? and segment.to_i.between? 0, 255
    end
  end
end
