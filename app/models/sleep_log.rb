# frozen_string_literal: true

class SleepLog < ApplicationRecord
  # acts_as_paranoid # Maybe add soft-delete here?

  belongs_to :user

  before_save :calculate_sleep_duration
  before_create :set_uuid

  # created_at is always going to be the slept_at since we just create new records for new sleep
  def slept_at
    created_at
  end

  def calculate_sleep_duration
    return if woke_up_at.nil?

    time_difference = Time.zone.at((woke_up_at - created_at))
    self.duration = TimeConcern.format_duration(time_difference)
  end

  private

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
