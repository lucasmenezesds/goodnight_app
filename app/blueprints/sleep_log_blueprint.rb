# frozen_string_literal: true

class SleepLogBlueprint < Blueprinter::Base
  identifier :uuid

  view :with_user_name do
    field :user_name do |log, _options|
      log.user.name
    end
  end

  field :user_id
  field :slept_at, datetime_format: TimeConcern::STANDARD_DATETIME_FORMAT
  field :woke_up_at, datetime_format: TimeConcern::STANDARD_DATETIME_FORMAT
  field :duration, datetime_format: TimeConcern::STANDARD_DURATION_FORMAT
end
