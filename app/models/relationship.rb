# frozen_string_literal: true

class Relationship < ApplicationRecord
  acts_as_paranoid

  belongs_to :source, class_name: 'User'
  belongs_to :target, class_name: 'User'

  validate :follower_cannot_be_the_same_as_followed

  private

  def follower_cannot_be_the_same_as_followed
    return unless source_id == target_id

    errors.add(:target_id, 'Follower cannot be the same as the Followed')
  end
end
