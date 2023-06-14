# frozen_string_literal: true

class User < ApplicationRecord
  self.implicit_order_column = 'created_at'

  acts_as_paranoid

  validates :name, presence: true

  has_many :sleep_logs, dependent: :destroy

  has_many :is_following, class_name: 'Relationship', foreign_key: 'source_id', inverse_of: :source, dependent: :destroy
  has_many :is_followed, class_name: 'Relationship', foreign_key: 'target_id', inverse_of: :target, dependent: :destroy

  has_many :following, through: :is_following, source: :target
  has_many :followers, through: :is_followed, source: :source
end
