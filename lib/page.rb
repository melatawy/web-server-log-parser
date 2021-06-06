# frozen_string_literal: true

#
# A representation of a unique URL and tracks ip based visits visits
#
class Page
  def initialize(url)
    @url = url
    @all_visits = {}
    @all_visits.default = 0
  end

  def add_visit(ip)
    @all_visits[ip] += 1
  end

  def visits
    @all_visits.map { |_ip, c| c }.reduce(:+) or 0
  end

  def unique_visits
    @all_visits.keys.count
  end
end
