# frozen_string_literal: true

FactoryBot.define do
  factory :relationship do
    association :source, factory: User
    association :target, factory: User

    trait :deleted do
      deleted_at { Faker::Time.between(from: DateTime.now - 365, to: DateTime.now) }
    end
  end
end
