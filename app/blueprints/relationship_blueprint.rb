# frozen_string_literal: true

class RelationshipBlueprint < Blueprinter::Base
  identifier :id, name: :user_id

  view :with_user_name do
    field :user_name do |user, _options|
      user.name
    end
  end

  view :all_relationships do
    field :following do |_user, options|
      UserBlueprint.render_as_hash(options[:following])
    end

    field :followers do |_user, options|
      UserBlueprint.render_as_hash(options[:followers])
    end
  end
end
