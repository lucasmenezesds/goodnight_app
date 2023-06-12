# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    deleted_at { nil }
  end

  trait :deleted do
    deleted_at { Faker::Time.between(from: DateTime.now - 365, to: DateTime.now) }
  end
end
