# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::SleepLogsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/users/:user_id/sleep_logs').to route_to('api/v1/sleep_logs#index', user_id: ':user_id')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/users/:user_id/sleep_logs').to route_to('api/v1/sleep_logs#create', user_id: ':user_id')
    end

    it 'routes to #last' do
      expect(get: '/api/v1/users/:user_id/sleep_logs/last').to route_to('api/v1/sleep_logs#last', user_id: ':user_id')
    end
  end
end
