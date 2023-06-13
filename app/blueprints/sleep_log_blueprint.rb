# frozen_string_literal: true

class SleepLogBlueprint < Blueprinter::Base
  identifier :id

  field :user_id
  field :created_at, datetime_format: '%Y-%m-%dT%H:%M:%S'
end
