# frozen_string_literal: true

#
# Monkeypatch String
# Adding .blank? method to check nil or empty
#
class String
  def blank?
    nil? || empty?
  end

  def integer?
    self == /\A[-+]?\d+\z/
  end
end
