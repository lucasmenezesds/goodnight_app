# frozen_string_literal: true

class User < ApplicationRecord
  self.implicit_order_column = 'created_at'

  acts_as_paranoid

  validates :name, presence: true

  has_many :sleep_logs, dependent: :destroy
end
