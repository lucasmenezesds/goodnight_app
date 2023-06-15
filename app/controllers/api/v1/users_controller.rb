# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /api/v1/users
  def index
    all_users = User.select(:id, :name).all
    render json: { data: UserBlueprint.render_as_json(all_users) }, status: :ok
  end

  # GET /api/v1/users/:id
  def show
    render json: { data: UserBlueprint.render_as_json(@user) }, status: :ok
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])

    user_not_found(@user)
  end

  def user_not_found(user_data)
    render json: { errors: { message: 'User was not found' }, data: {} }, status: :unprocessable_entity if user_data.nil?
  end
end
