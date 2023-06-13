# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::SleepLogsController do
  let!(:timestamp) { 8.hours.ago.strftime('%Y-%m-%dT%H:%M:%S') }
  let!(:timestamp2) { 32.hours.ago.strftime('%Y-%m-%dT%H:%M:%S') }

  let(:user) { create(:user) }
  let(:valid_attributes) { { user_id: user.id, created_at: timestamp } }
  let(:valid_attributes2) { { user_id: user.id, created_at: timestamp2 } }
  let(:invalid_attributes) { { deleted_at: 3.hours.ago } }

  describe 'GET /api/v1/users/:user_id/sleep_logs' do
    it 'renders a successful response' do
      log1 = SleepLog.create!(valid_attributes)
      log2 = SleepLog.create!(valid_attributes2)

      get "/api/v1/users/#{user.id}/sleep_logs", headers: {}, as: :json

      expected_data = [
        { id: log1.id, user_id: user.id, created_at: timestamp }.stringify_keys,
        { id: log2.id, user_id: user.id, created_at: timestamp2 }.stringify_keys
      ]

      expect(response).to be_successful
      expect(response.parsed_body).to eq({ 'data' => expected_data })
    end
  end

  describe 'GET /api/v1/users/:user_id/sleep_logs/last' do
    it 'renders a successful response' do
      sleep_log = SleepLog.create! valid_attributes

      get "/api/v1/users/#{user.id}/sleep_logs/last", headers: {}, as: :json

      expect(response).to be_successful
      expect(response.parsed_body).to eq({ 'data' => SleepLogBlueprint.render_as_json(sleep_log) })
    end
  end

  describe 'POST /api/v1/users/:user_id/sleep_logs' do
    context 'when the request is successful' do
      it 'creates a new Api::V1::Users::SleepLog' do
        expect do
          post "/api/v1/users/#{user.id}/sleep_logs", params: {}, headers: {}, as: :json

          response_keys = response.parsed_body.fetch('data').keys
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including('application/json'))
          expect(response_keys).to match_array(%w[id user_id created_at])
        end.to change(SleepLog, :count).by(1)
      end
    end
  end
end
