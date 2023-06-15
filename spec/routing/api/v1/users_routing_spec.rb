# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UsersController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/users').to route_to('api/v1/users#index')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/users/:id').to route_to('api/v1/users#show', id: ':id')
    end
  end
end
