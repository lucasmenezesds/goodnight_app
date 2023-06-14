# frozen_string_literal: true

require 'rails_helper'

describe SleepLog do
  describe '#create' do
    let!(:timecop_time) { Time.zone.now }
    let(:user) { create(:user) }

    it 'creates the log successfully for the given user' do
      expect do
        user.sleep_logs.create
      end.to change { user.sleep_logs.count }.by(1)
    end

    context 'when the SleepLog is slept only' do
      it 'contains the expected attributes' do
        Timecop.freeze(timecop_time) do
          created_log = user.sleep_logs.create

          expect(TimeConcern.format_datetime(created_log.slept_at)).to eq(TimeConcern.format_datetime(timecop_time))
          expect(created_log.woke_up_at).to be_nil
          expect(created_log.duration).to be_nil
          expect(created_log.uuid).not_to be_nil
          expect(created_log.user_id).to eq(user.id)
        end
      end
    end
  end
end
