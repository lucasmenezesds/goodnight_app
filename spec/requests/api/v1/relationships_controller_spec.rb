# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::RelationshipsController do
  let(:user_a) { create(:user, name: 'UserA') }
  let(:user_b) { create(:user, name: 'UserB') }
  let(:user_c) { create(:user, name: 'UserC') }
  let(:user_d) { create(:user, name: 'UserD') }
  let(:user_e) { create(:user, name: 'UserE') }

  describe 'GET /api/v1/users/:user_id/relationships' do
    before do
      create(:relationship, source: user_a, target: user_b) # UserA => UserB
      create(:relationship, source: user_a, target: user_c) # UserA => UserC
      create(:relationship, source: user_b, target: user_a) # UserB => UserA
      create(:relationship, source: user_c, target: user_a) # UserC => UserA
      create(:relationship, source: user_d, target: user_a) # UserD => UserA
    end

    context 'when user follows and has followers' do
      it 'renders a successful response with present following and followers data' do
        get "/api/v1/users/#{user_a.id}/relationships", headers: {}, as: :json

        expected_data = {
          'user_id' => user_a.id,
          'following' => [
            { user_id: user_b.id, name: user_b.name }.stringify_keys,
            { user_id: user_c.id, name: user_c.name }.stringify_keys
          ],
          'followers' => [
            { user_id: user_b.id, name: user_b.name }.stringify_keys,
            { user_id: user_c.id, name: user_c.name }.stringify_keys,
            { user_id: user_d.id, name: user_d.name }.stringify_keys
          ]
        }

        expect(response).to be_successful
        expect(response.parsed_body).to eq({ 'data' => expected_data })
      end
    end

    context 'when user doesnt have any follower and doesnt follow anyone' do
      it 'renders a successful response with present empty following and followers data' do
        get "/api/v1/users/#{user_e.id}/relationships", headers: {}, as: :json

        expected_data = {
          'user_id' => user_e.id,
          'following' => [],
          'followers' => []
        }

        expect(response).to be_successful
        expect(response.parsed_body).to eq({ 'data' => expected_data })
      end
    end

    context 'when user doesnt have any followers and but follows people' do
      it 'renders a successful response with present empty following but present followers data' do
        get "/api/v1/users/#{user_d.id}/relationships", headers: {}, as: :json

        expected_data = {
          'user_id' => user_d.id,
          'followers' => [],
          'following' => [
            { user_id: user_a.id, name: user_a.name }.stringify_keys
          ]
        }

        expect(response).to be_successful
        expect(response.parsed_body).to eq({ 'data' => expected_data })
      end
    end
  end

  describe 'POST /api/v1/users/:user_id/relationships' do
    context 'when user follows a new person' do
      it 'renders a successful response with the followed user_id and user_name' do
        post "/api/v1/users/#{user_a.id}/relationships/#{user_b.id}", headers: {}, as: :json

        expected_response = {
          'message' => 'Followed Successfully',
          'data' => {
            'user_id' => user_b.id,
            'user_name' => user_b.name
          }
        }

        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to eq(expected_response)
      end
    end

    context 'when user try to follows himself' do
      it 'renders an error message with :unprocessable_entity status' do
        post "/api/v1/users/#{user_a.id}/relationships/#{user_a.id}", headers: {}, as: :json

        expected_errors = { 'message' => 'This is not a valid user',
                            'received_user_id' => user_a.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to eq({ 'errors' => expected_errors, 'data' => {} })
      end
    end

    context 'when user try to follows someone that the user is already following' do
      it 'renders an error message with :unprocessable_entity status' do
        create(:relationship, source: user_a, target: user_b) # UserA => UserB

        post "/api/v1/users/#{user_a.id}/relationships/#{user_b.id}", headers: {}, as: :json

        expected_errors = { 'message' => 'You are already following this person',
                            'received_user_id' => user_b.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to eq({ 'errors' => expected_errors, 'data' => {} })
      end
    end

    context 'when user try to follows someone that doesnt exist' do
      it 'renders an error message with :unprocessable_entity status' do
        post "/api/v1/users/#{user_a.id}/relationships/doest_exist_id", headers: {}, as: :json

        expected_errors = { 'message' => 'User was not found' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to eq({ 'errors' => expected_errors, 'data' => {} })
      end
    end
  end

  describe 'DELETE /api/v1/users/:user_id/relationships' do
    context 'when user unfollows a person he is following' do
      it 'renders a successful response with the UNFOLLOWED user_id and user_name' do
        create(:relationship, source: user_e, target: user_d) # UserA => UserB
        delete "/api/v1/users/#{user_e.id}/relationships/#{user_d.id}", headers: {}, as: :json

        expected_response = {
          'message' => 'Unfollowed Successfully',
          'data' => { 'user_id' => user_d.id,
                      'user_name' => user_d.name }
        }

        expect(response).to be_successful
        expect(response.parsed_body).to eq(expected_response)
      end
    end

    context 'when user try to unfollow someone that he doesnt follow' do
      it 'renders an error message with :unprocessable_entity status' do
        delete "/api/v1/users/#{user_e.id}/relationships/#{user_d.id}", headers: {}, as: :json

        expected_errors = { 'message' => 'You are not following this person',
                            'received_user_id' => user_d.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to eq({ 'errors' => expected_errors, 'data' => {} })
      end
    end

    context 'when user try to unfollow someone that doest exist' do
      it 'renders an error message with :unprocessable_entity status' do
        delete "/api/v1/users/#{user_e.id}/relationships/doest_exist_id", headers: {}, as: :json

        expected_errors = { 'message' => 'User was not found' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to eq({ 'errors' => expected_errors, 'data' => {} })
      end
    end
  end
end
