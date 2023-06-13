# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_paranoid

  validates :name, presence: true

  has_many :sleep_logs, dependent: :destroy
end
