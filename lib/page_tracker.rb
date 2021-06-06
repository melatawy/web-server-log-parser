# frozen_string_literal: true

autoload :Page, 'page'

#
# Tracks all pages and gathers all required stats
#
class PageTracker
  def initialize
    @pages = {}
  end

  def add_all(log_lines)
    log_lines.each { |line| add_log_line line }
  end

  def add_log_line(log_line)
    validate_log_line log_line
    unless @pages.include? log_line[:url]
      @pages[log_line[:url]] = Page.new log_line[:url]
    end
    @pages[log_line[:url]].add_visit log_line[:ip]
  end

  def visits
    @pages
      .sort { |a, b| b[1].visits <=> a[1].visits }
      .collect { |page| { page[0] => page[1].visits } }
  end

  def unique_visits
    @pages
      .sort { |a, b| b[1].unique_visits <=> a[1].unique_visits }
      .collect { |page| { page[0] => page[1].unique_visits } }
  end

  private

  def validate_log_line(log_line)
    raise 'Object empty' if log_line.nil?
    raise 'No URL given' if log_line[:url].blank?
    raise 'No IP given' if log_line[:ip].blank?
  end
end
