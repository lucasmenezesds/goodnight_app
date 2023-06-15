# frozen_string_literal: true

require 'rails_helper'

describe SleepLogService, type: :service do
  let!(:sleep_log_uuid) { SecureRandom.uuid }
  let(:user) { create(:user, name: 'UserA') }
  let(:sleep_log) { build_stubbed(:sleep_log, user: user, uuid: sleep_log_uuid) }
  let(:full_sleep_log) { build_stubbed(:sleep_log, :eight_hours_sleep, user: user, uuid: sleep_log_uuid) }

  describe '#log_sleep_data' do
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

  context 'when testing logs from followers and people user is following' do
    let(:user_b) { create(:user, name: 'UserB') }
    let(:user_c) { create(:user, name: 'UserC') }
    let(:user_d) { create(:user, name: 'UserD') }
    let(:user_e) { create(:user, name: 'UserE') }

    before do
      create(:relationship, source: user, target: user_b) # UserA => UserB*
      create(:relationship, source: user, target: user_c) # UserA => UserC*
      create(:relationship, source: user_b, target: user) # UserB => UserA
      create(:relationship, source: user_b, target: user_d) # UserB => UserD
      create(:relationship, source: user_d, target: user) # UserD => UserA
      create(:relationship, source: user_d, target: user_c) # UserD => UserC

      time_now = Time.zone.parse('2023-06-15T16:52:23')
      Timecop.freeze(time_now) do
        # UserA
        create(:sleep_log, user: user, created_at: time_now - 2.hours, woke_up_at: time_now) # 2 hours
        create(:sleep_log, user: user, created_at: 3.days.ago - 4.hours, woke_up_at: 3.days.ago) # 4 hours
        create(:sleep_log, user: user, created_at: 10.days.ago - 6.5.hours, woke_up_at: 10.days.ago) # 6.5 hours
        # UserB*
        create(:sleep_log, user: user_b, created_at: time_now - 8.hours, woke_up_at: time_now) # 8 hours
        create(:sleep_log, user: user_b, created_at: 7.days.ago - 4.hours, woke_up_at: 7.days.ago) # 4 hours
        create(:sleep_log, user: user_b, created_at: 8.days.ago - 5.hours, woke_up_at: 8.days.ago) # 5 hours
        create(:sleep_log, user: user_b, created_at: 10.days.ago - 10.hours, woke_up_at: 10.days.ago) # 10 hours
        # UserC*
        create(:sleep_log, user: user_c, created_at: time_now - 7.hours, woke_up_at: time_now) # 7 hours
        create(:sleep_log, user: user_c, created_at: 7.days.ago - 3.hours, woke_up_at: 7.days.ago) # 3 hours
        create(:sleep_log, user: user_c, created_at: 6.days.ago - 4.5.hours, woke_up_at: 6.days.ago) # 4.5 hours
        create(:sleep_log, user: user_c, created_at: 9.days.ago - 9.5.hours, woke_up_at: 9.days.ago) # 9.5 hours
        create(:sleep_log, user: user_c, created_at: 20.days.ago - 8.5.hours, woke_up_at: 20.days.ago) # 8.5 hours
        # UserD
        create(:sleep_log, user: user_d, created_at: time_now - 10.hours, woke_up_at: time_now) # 10 hours
        create(:sleep_log, user: user_d, created_at: 4.days.ago - 6.hours, woke_up_at: 4.days.ago) # 6 hours
        create(:sleep_log, user: user_d, created_at: 8.days.ago - 4.hours, woke_up_at: 8.days.ago) # 4 hours
        create(:sleep_log, user: user_d, created_at: 10.days.ago - 9.hours, woke_up_at: 10.days.ago) # 9 hours
      end
    end

    describe '#logs_from_people_user_is_following' do
      context 'when the user is not following anyone' do
        it 'returns an empty array' do
          result = described_class.logs_from_people_user_is_following(user_c)

          expect(result).to be_empty
        end
      end

      context 'when the user is following some people' do
        it 'returns an the expected data from the previous week (June 4th to June 11th)' do
          result = described_class.logs_from_people_user_is_following(user)

          expected_result = [
            { duration: '10:00:00', user_id: user_b.id },
            { duration: '09:30:00', user_id: user_c.id },
            { duration: '05:00:00', user_id: user_b.id },
            { duration: '04:30:00', user_id: user_c.id },
            { duration: '04:00:00', user_id: user_b.id },
            { duration: '03:00:00', user_id: user_c.id }
          ]

          mapped_data = result.map { |log| { duration: log.duration.strftime('%H:%M:%S'), user_id: log.user_id } }

          expect(result.size).to eq(6)
          expect(mapped_data).to eq(expected_result)
        end
      end
    end

    describe '#logs_from_followers' do
      context 'when the user has no follower' do
        it 'returns an empty array' do
          result = described_class.logs_from_followers(user_e)

          expect(result).to be_empty
        end
      end

      context 'when the user has some followers' do
        it 'returns an the expected data from the previous week (June 4th to June 11th)' do
          result = described_class.logs_from_followers(user_c)

          expected_result = [
            { duration: '09:00:00', user_id: user_d.id },
            { duration: '06:30:00', user_id: user.id },
            { duration: '04:00:00', user_id: user_d.id }
          ]

          mapped_data = result.map { |log| { duration: log.duration.strftime('%H:%M:%S'), user_id: log.user_id } }

          expect(result.size).to eq(3)
          expect(mapped_data).to eq(expected_result)
        end
      end
    end
  end
end
