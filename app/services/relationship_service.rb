# frozen_string_literal: true

module RelationshipService
  def self.follow(user, person)
    person_to_follow = retrieve_person(person)

    response = user.follow(person_to_follow)

    if response.present? && response.persisted?
      successful_action(person_to_follow, :followed)
    else
      invalid_user_message(nil, person)
    end
  rescue ActiveRecord::RecordNotUnique
    failed_action('You are already following this person', person_to_follow&.id)
  end

  def self.unfollow(user, person)
    person_to_unfollow = retrieve_person(person)
    response = user.unfollow(person_to_unfollow)

    if response.present?
      successful_action(person_to_unfollow, :unfollowed)
    else
      failed_action('You are not following this person', person_to_unfollow&.id)
    end
  rescue StandardError
    invalid_user_message(nil, person)
  end

  def self.following?(user, person)
    user.following?(person)
  end

  def self.retrieve_person(person)
    if person.is_a?(User)
      person
    else
      find_user!(person)
    end
  end

  def self.find_user!(person_to_follow_id)
    person = User.find_by(id: person_to_follow_id)
    raise StandardError unless person.respond_to?(:id)

    person
  end

  def self.successful_action(user_data, action)
    { status: :ok, message: "#{action.to_s.capitalize} user", received_user_data: user_data }
  end

  def self.failed_action(error_message, user_data)
    user_id = user_data&.try(:id) || user_data
    { status: :error, errors: { message: error_message, received_user_id: user_id } }
  end

  def self.invalid_user_message(message = nil, received_user_id = nil)
    message ||= 'This is not a valid user'
    failed_action(message, received_user_id)
  end
end
