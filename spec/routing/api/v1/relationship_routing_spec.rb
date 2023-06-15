# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::RelationshipsController do
  describe 'routing' do
    it 'routes to #index (to list who the user follows and who is following him)' do
      expect(get: '/api/v1/users/:user_id/relationships/').to route_to('api/v1/relationships#index', user_id: ':user_id')
    end

    it 'routes to #following (to list who the user is following)' do
      expect(get: '/api/v1/users/:user_id/relationships/following').to route_to('api/v1/relationships#following', user_id: ':user_id')
    end

    it 'routes to #followers (to list who follows the user)' do
      expect(get: '/api/v1/users/:user_id/relationships/followers').to route_to('api/v1/relationships#followers', user_id: ':user_id')
    end

    it 'routes to #follow (to follow someone)' do
      expect(post: '/api/v1/users/:user_id/relationships/:other_user_id').to route_to('api/v1/relationships#follow',
                                                                                      user_id: ':user_id',
                                                                                      other_user_id: ':other_user_id')
    end

    it 'routes to #unfollow (to unfollow someone)' do
      expect(delete: '/api/v1/users/:user_id/relationships/:other_user_id').to route_to('api/v1/relationships#unfollow',
                                                                                        user_id: ':user_id',
                                                                                        other_user_id: ':other_user_id')
    end

    it 'routes to /following/sleep_logs' do
      expect(get: '/api/v1/users/:user_id/relationships/following/sleep_logs').to route_to('api/v1/relationships#sleep_logs_from_users_im_following',
                                                                                           user_id: ':user_id')
    end

    it 'routes to /followers/sleep_logs' do
      expect(get: '/api/v1/users/:user_id/relationships/followers/sleep_logs').to route_to('api/v1/relationships#sleep_logs_from_my_followers',
                                                                                           user_id: ':user_id')
    end
  end
end
