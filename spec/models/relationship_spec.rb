# frozen_string_literal: true

require 'rails_helper'

describe Relationship do
  let(:user_a) { create(:user, name: 'UserA') }
  let(:user_b) { create(:user, name: 'UserB') }
  let(:user_c) { create(:user, name: 'UserC') }
  let(:user_d) { create(:user, name: 'UserD') }

  context 'when UserA is Following UserB but UserB is not Following UserA' do
    before do
      create(:relationship, source: user_a, target: user_b) # UserA => UserB
    end

    describe '#FOLLOWING' do
      it 'returns UserB name when asked the people UserA is FOLLOWING' do
        names_user_a_is_following = user_a.following.pluck(:name)

        expect(names_user_a_is_following).to include('UserB')
      end

      it 'returns an empty array of name when asked the people UserB is FOLLOWING' do
        names_user_b_is_following = user_b.following.pluck(:name)

        expect(names_user_b_is_following).to be_empty
      end
    end

    describe '#FOLLOWERS' do
      it 'returns an empty array when asked who FOLLOWS UserA' do
        names_user_a_has_as_followers = user_a.followers.pluck(:name)

        expect(names_user_a_has_as_followers).to be_empty
      end

      it 'returns UserA name when asked who FOLLOWS UserB' do
        names_user_b_has_as_followers = user_b.followers.pluck(:name)

        expect(names_user_b_has_as_followers).to include('UserA')
      end
    end
  end

  context 'when UserA is Following UserB, UserC & UserD. While UserB follows UserA and UserD' do
    before do
      create(:relationship, source: user_a, target: user_b) # UserA => UserB
      create(:relationship, source: user_a, target: user_c) # UserA => UserC
      create(:relationship, source: user_a, target: user_d) # UserA => UserD
      create(:relationship, source: user_b, target: user_a) # UserB => UserA
      create(:relationship, source: user_b, target: user_d) # UserB => UserD
      create(:relationship, source: user_d, target: user_b) # UserD => UserB
    end

    describe '#FOLLOWING' do
      it 'returns the expected names when asked the people UserA is FOLLOWING' do
        names_user_a_is_following = user_a.following.pluck(:name)

        expect(names_user_a_is_following).to match_array(%w[UserB UserC UserD])
      end

      it 'returns the expected names when asked the people UserB is FOLLOWING' do
        names_user_b_is_following = user_b.following.pluck(:name)

        expect(names_user_b_is_following).to match_array(%w[UserA UserD])
      end

      it 'returns the expected name when asked the people UserD is FOLLOWING' do
        names_user_d_is_following = user_d.following.pluck(:name)

        expect(names_user_d_is_following).to match_array(%w[UserB])
      end

      it 'returns an empty array when asked the people UserC is FOLLOWING' do
        names_user_c_is_following = user_c.following.pluck(:name)

        expect(names_user_c_is_following).to be_empty
      end
    end

    describe '#FOLLOWERS' do
      it 'returns UserB when asked who FOLLOWS UserA' do
        names_user_a_has_as_followers = user_a.followers.pluck(:name)

        expect(names_user_a_has_as_followers).to match_array(%w[UserB])
      end

      it 'returns UserA,UserD names when asked who FOLLOWS UserB' do
        names_user_b_has_as_followers = user_b.followers.pluck(:name)

        expect(names_user_b_has_as_followers).to match_array(%w[UserA UserD])
      end

      it 'returns UserA,UserD names when asked who FOLLOWS UserC' do
        names_user_c_has_as_followers = user_c.followers.pluck(:name)

        expect(names_user_c_has_as_followers).to match_array(%w[UserA])
      end

      it 'returns UserA,UserD names when asked who FOLLOWS UserD' do
        names_user_d_has_as_followers = user_d.followers.pluck(:name)

        expect(names_user_d_has_as_followers).to match_array(%w[UserA UserB])
      end
    end
  end
end
