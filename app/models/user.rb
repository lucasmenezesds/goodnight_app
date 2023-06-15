# frozen_string_literal: true

class User < ApplicationRecord
  self.implicit_order_column = 'created_at'

  acts_as_paranoid

  validates :name, presence: true

  has_many :sleep_logs, dependent: :destroy

  has_many :following_relationships, class_name: 'Relationship', foreign_key: 'source_id', inverse_of: :source, dependent: :destroy
  has_many :followed_relationships, class_name: 'Relationship', foreign_key: 'target_id', inverse_of: :target, dependent: :destroy

  has_many :following, through: :following_relationships, source: :target
  has_many :followers, through: :followed_relationships, source: :source

  def follow(user_to_follow)
    following = following_relationships.with_deleted.find_by(target_id: user_to_follow.id)
    if following.present? && following.deleted?
      following.restore
    else
      following_relationships.create(target_id: user_to_follow.id)
    end
  end

  def unfollow(user_to_unfollow)
    # noinspection RubyRedundantSafeNavigation
    following_relationships.find_by(target_id: user_to_unfollow.id)&.destroy
  end

  def following?(user)
    following.include?(user)
  end
end
