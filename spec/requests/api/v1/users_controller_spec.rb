# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UsersController do
  let!(:user_a) { create(:user, name: 'UserA') }
  let!(:user_b) { create(:user, name: 'UserB') }

  describe 'GET /api/v1/users' do
    it 'renders a successful response with all users records' do
      get '/api/v1/users', headers: {}, as: :json

      expected_data = [
        { user_id: user_a.id, name: user_a.name }.stringify_keys,
        { user_id: user_b.id, name: user_b.name }.stringify_keys
      ]
      pagination_expected_data = { 'page_number' => 1, 'per_page' => 50, 'total_items' => 2 }

      expect(response).to be_successful
      expect(response.parsed_body).to eq({ 'data' => expected_data, 'pagination' => pagination_expected_data })
    end
  end

  describe 'GET /api/v1/users/:id' do
    it 'renders a successful response with the specific user data' do
      get "/api/v1/users/#{user_b.id}", headers: {}, as: :json

      expected_data = { 'user_id' => user_b.id, 'name' => user_b.name }

      expect(response).to be_successful
      expect(response.parsed_body).to eq({ 'data' => expected_data })
    end

    it 'renders an error if user is not found' do
      get '/api/v1/users/random_id', headers: {}, as: :json

      expected_response = { 'errors' => { 'message' => 'User was not found' }, 'data' => {} }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body).to eq(expected_response)
    end
  end
end
