# frozen_string_literal: true

class Api::V1::RelationshipsController < ApplicationController
  before_action :set_user
  before_action :set_other_user, only: %i[follow unfollow]

  # GET /api/v1/users/:user_id/relationships
  def index
    following = @user.following
    followers = @user.followers

    render json: { data: RelationshipBlueprint.render_as_json(@user,
                                                              view: :all_relationships,
                                                              following: following,
                                                              followers: followers) }, status: :ok
  end

  # POST /api/v1/users/:user_id/relationships/:other_user_id
  def follow
    response = RelationshipService.follow(@user, @other_user)

    if response[:status] == :ok
      render json: { message: 'Followed Successfully',
                     data: RelationshipBlueprint.render_as_json(response[:received_user_data], view: :with_user_name) }, status: :created
    else
      render json: { errors: response[:errors], data: {} }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:user_id/relationships/:other_user_id
  def unfollow
    response = RelationshipService.unfollow(@user, @other_user)

    if response[:status] == :ok
      render json: { message: 'Unfollowed Successfully',
                     data: RelationshipBlueprint.render_as_json(response[:received_user_data], view: :with_user_name) }, status: :ok
    else
      render json: { errors: response[:errors], data: {} }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/users/:user_id/relationships/following
  def following
    following = @user.following

    render json: { data: RelationshipBlueprint.render_as_json(@user,
                                                              view: :following_relationships,
                                                              following: following) }, status: :ok
  end

  # GET /api/v1/users/:user_id/relationships/followers
  def followers
    followers = @user.followers

    render json: { data: RelationshipBlueprint.render_as_json(@user,
                                                              view: :followers_relationships,
                                                              followers: followers) }, status: :ok
  end

  # GET /api/v1/users/:user_id/relationships/following/sleep_logs
  def sleep_logs_from_users_im_following
    @sleep_logs = SleepLogService.logs_from_people_user_is_following(@user)

    render json: { data: SleepLogBlueprint.render_as_json(@sleep_logs, view: :with_user_name) }, status: :ok
  end

  # GET /api/v1/users/:user_id/relationships/followers/sleep_logs
  def sleep_logs_from_my_followers
    @sleep_log = SleepLogService.logs_from_followers(@user)

    render json: { data: SleepLogBlueprint.render_as_json(@sleep_log, view: :with_user_name) }, status: :ok
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])

    user_not_found(@user)
  end

  def set_other_user
    @other_user = User.find_by(id: params[:other_user_id])

    user_not_found(@other_user)
  end

  def user_not_found(user_data)
    render json: { errors: { message: 'User was not found' }, data: {} }, status: :unprocessable_entity if user_data.nil?
  end
end
