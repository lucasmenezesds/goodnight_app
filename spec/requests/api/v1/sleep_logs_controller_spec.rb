# frozen_string_literal: true

require 'rails_helper'

def expect_successful_created_response
  expect(response).to have_http_status(:created)
  expect(response.content_type).to match(a_string_including('application/json'))
end

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
        { uuid: log1.uuid, user_id: user.id, slept_at: timestamp, duration: nil, woke_up_at: nil }.stringify_keys,
        { uuid: log2.uuid, user_id: user.id, slept_at: timestamp2, duration: nil, woke_up_at: nil }.stringify_keys
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
    context "when it's the first time the user is creating a SleepLog" do
      it 'creates a new SleepLog' do
        expect do
          post "/api/v1/users/#{user.id}/sleep_logs", params: {}, headers: {}, as: :json

          response_keys = response.parsed_body.fetch('data').keys
          expect_successful_created_response
          expect(response_keys).to match_array(%w[uuid user_id slept_at woke_up_at duration])
        end.to change(SleepLog, :count).by(1)
      end
    end

    context 'when the user is requesting the endpoint to record the wake up time' do
      it 'updates the last SleepLog adding the woke_up_at and duration values' do
        woke_up_time = Time.zone.now
        expected_woke_up_time = TimeConcern.format_datetime(woke_up_time)
        log = SleepLog.create!(valid_attributes)

        expect do
          Timecop.freeze(woke_up_time) do
            post "/api/v1/users/#{user.id}/sleep_logs", params: {}, headers: {}, as: :json
          end

          response_data = response.parsed_body.fetch('data')
          expectations = {
            'uuid' => log.uuid,
            'user_id' => user.id,
            'slept_at' => timestamp,
            'woke_up_at' => expected_woke_up_time,
            'duration' => '08:00:00'
          }

          expect_successful_created_response
          expect(response_data['uuid']).to eq(expectations['uuid'])
          expect(response_data['user_id']).to eq(expectations['user_id'])
          expect(response_data['slept_at']).to eq(expectations['slept_at'])
          expect(response_data['woke_up_at']).to eq(expectations['woke_up_at'])
          expect(response_data['duration']).to eq(expectations['duration'])
        end.not_to change(SleepLog, :count)
      end
    end

    context 'when the user already have some SleepLogs and is creating a new sleeping time' do
      it 'created a new SleepLog adding the woke_up_at and duration values' do
        slept_at = Time.zone.now
        expected_slept_at = TimeConcern.format_datetime(slept_at)
        log = SleepLog.create!(valid_attributes2.merge({ woke_up_at: 24.hours.ago }))

        expect do
          Timecop.freeze(slept_at) do
            post "/api/v1/users/#{user.id}/sleep_logs", params: {}, headers: {}, as: :json
          end

          response_data = response.parsed_body.fetch('data')

          expectations = {
            'uuid' => log.id,
            'user_id' => user.id,
            'slept_at' => expected_slept_at,
            'woke_up_at' => nil,
            'duration' => nil
          }

          expect_successful_created_response
          expect(user.sleep_logs.size).to eq(2)
          expect(response_data['uuid']).not_to eq(expectations['uuid'])
          expect(response_data['user_id']).to eq(expectations['user_id'])
          expect(response_data['slept_at']).to eq(expectations['slept_at'])
          expect(response_data['woke_up_at']).to eq(expectations['woke_up_at'])
          expect(response_data['duration']).to eq(expectations['duration'])
        end.to change(SleepLog, :count).by(1)
      end
    end
  end
end
