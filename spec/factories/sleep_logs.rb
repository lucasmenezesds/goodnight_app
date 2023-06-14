# frozen_string_literal: true

FactoryBot.define do
  factory :sleep_log do
    association :user
    created_at { 16.hours.ago }
  end

  trait :eight_hours_sleep do
    woke_up_at { 8.hours.ago }
    duration { '08:00' }
  end
end
