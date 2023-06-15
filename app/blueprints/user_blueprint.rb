# frozen_string_literal: true

class UserBlueprint < Blueprinter::Base
  identifier :id, name: :user_id

  field :name
end
