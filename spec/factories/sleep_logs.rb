# frozen_string_literal: true

FactoryBot.define do
  factory :sleep_log do
    association :user
    created_at { 8.hours.ago }
  end
end
