# frozen_string_literal: true

class SleepLog < ApplicationRecord
  # acts_as_paranoid # Maybe add soft-delete here?

  belongs_to :user

  before_create :set_uuid

  # created_at is always going to be the slept_at since we just create new records for new sleep
  def slept_at
    created_at
  end

  private

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
