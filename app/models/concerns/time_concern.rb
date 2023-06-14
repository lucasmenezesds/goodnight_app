# frozen_string_literal: true

module TimeConcern
  STANDARD_DATETIME_FORMAT = '%Y-%m-%dT%H:%M:%S'
  STANDARD_DURATION_FORMAT = '%H:%M:%S'

  def self.format_datetime(time)
    time.strftime(STANDARD_DATETIME_FORMAT)
  end

  def self.format_duration(time)
    time.strftime(STANDARD_DURATION_FORMAT)
  end
end
