# frozen_string_literal: true

require 'rails_helper'

describe SleepLogService, type: :service do
  let!(:sleep_log_uuid) { SecureRandom.uuid }
  let(:user) { build_stubbed(:user) }
  let(:sleep_log) { build_stubbed(:sleep_log, user: user, uuid: sleep_log_uuid) }
  let(:full_sleep_log) { build_stubbed(:sleep_log, :eight_hours_sleep, user: user, uuid: sleep_log_uuid) }

  context 'when the user has no SleepLogs' do
    it 'returns a new SleepLog record' do
      result = described_class.log_sleep_data(user)

      expect(result).to be_new_record
      expect(result.woke_up_at).to be_nil
      expect(result.duration).to be_nil
    end
  end

  context 'when the user has a SleepLog but without woke_up_at filled' do
    it 'returns the last SleepLog with the woke_up_at attribute filled' do
      expect(user).to receive_message_chain(:sleep_logs, :last).and_return(sleep_log)

      result = described_class.log_sleep_data(user)

      expect(result.uuid).to eq(sleep_log_uuid)
      expect(result.woke_up_at).not_to be_nil
    end
  end

  context 'when the user already has a SleepLog with woke_up_at filled' do
    it 'returns a new SleepLog with the woke_up_at nil' do
      uuid = SecureRandom.uuid
      allow(user).to receive_message_chain(:sleep_logs, :last).and_return(full_sleep_log)
      expect(user).to receive_message_chain(:sleep_logs, :new).and_return(SleepLog.new(uuid: uuid))

      result = described_class.log_sleep_data(user)

      expect(result.uuid).to eq(uuid)
      expect(result.woke_up_at).to be_nil
      expect(result.duration).to be_nil
    end
  end
end
