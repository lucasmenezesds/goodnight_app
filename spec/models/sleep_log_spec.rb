# frozen_string_literal: true

require 'rails_helper'

describe SleepLog do
  describe '#create' do
    let(:user) { create(:user) }

    it 'creates the log successfully for the given user' do
      expect do
        user.sleep_logs.create(created_at: 10.hours.ago)
      end.to change { user.sleep_logs.count }.by(1)
    end
  end
end
