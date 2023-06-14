# frozen_string_literal: true

class Api::V1::SleepLogsController < ApplicationController
  before_action :set_user

  # GET /api/v1/users/:user_id/sleep_logs
  def index
    @sleep_log = @user.sleep_logs.order(created_at: :desc)

    render json: { data: SleepLogBlueprint.render_as_json(@sleep_log) }, status: :ok
  end

  # GET /api/v1/users/:user_id/sleep_logs/last
  def last
    last_log = @user.sleep_logs.last

    render json: { data: SleepLogBlueprint.render_as_json(last_log) }, status: :ok
  end

  # POST /api/v1/users/:user_id/sleep_logs
  def create
    @sleep_log = SleepLogService.log_sleep_data(@user)

    if @sleep_log.save
      render json: { data: SleepLogBlueprint.render_as_json(@sleep_log) }, status: :created
    else
      render json: { errors: @sleep_log.errors, data: {} }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
