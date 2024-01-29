# frozen_string_literal: true

class Api::V1::RelationshipsController < ApplicationController
  before_action :set_user
  before_action :set_other_user, only: %i[follow unfollow]

  # GET /api/v1/users/:user_id/relationships
  def index
    following = @user.following
    followers = @user.followers

    paginated_following = Kaminari.paginate_array(following).page(page).per(per_page)
    paginated_followers = Kaminari.paginate_array(followers).page(page).per(per_page)
    total_count = paginated_following.total_count + paginated_followers.total_count

    render json: paginate_at_option_data(@user, RelationshipBlueprint, total_count, options: { view: :all_relationships,
                                                                                               following: paginated_following,
                                                                                               followers: paginated_followers }),
           status: :ok
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
    paginated_following = Kaminari.paginate_array(following).page(page).per(per_page)
    total_count = paginated_following.total_count

    render json: paginate_at_option_data(@user, RelationshipBlueprint, total_count,
                                         options: { view: :following_relationships, following: paginated_following }),
           status: :ok
  end

  # GET /api/v1/users/:user_id/relationships/followers
  def followers
    followers = @user.followers
    paginated_followers = Kaminari.paginate_array(followers)
    total_count = paginated_followers.total_count

    render json: paginate_at_option_data(@user, RelationshipBlueprint, total_count,
                                         options: { view: :followers_relationships, followers: paginated_followers }),
           status: :ok
  end

  # GET /api/v1/users/:user_id/relationships/following/sleep_logs
  def sleep_logs_from_users_im_following
    @sleep_logs = SleepLogService.logs_from_people_user_is_following(@user)

    render json: paginate(@sleep_logs, SleepLogBlueprint, { view: :with_user_name }),
           status: :ok
  end

  # GET /api/v1/users/:user_id/relationships/followers/sleep_logs
  def sleep_logs_from_my_followers
    @sleep_logs = SleepLogService.logs_from_followers(@user)

    render json: paginate(@sleep_logs, SleepLogBlueprint, { view: :with_user_name }),
           status: :ok
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
