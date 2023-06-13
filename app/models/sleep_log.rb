# frozen_string_literal: true

class SleepLog < ApplicationRecord
  # acts_as_paranoid # Maybe add soft-delete here?

  belongs_to :user
end
