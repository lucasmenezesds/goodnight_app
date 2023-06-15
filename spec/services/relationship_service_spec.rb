# frozen_string_literal: true

require 'rails_helper'

describe RelationshipService, type: :service do
  let(:user_a) { create(:user, name: 'UserA') }
  let(:user_b) { create(:user, name: 'UserB') }

  describe '#retrieve_person' do
    context 'when the parameter IS NOT a User class' do
      it 'returns user_a when passed its id' do
        expect(described_class.retrieve_person(user_a.id)).to eq user_a
      end

      it 'raises an RecordNotFound if the user is not found' do
        expect { described_class.retrieve_person('wrong_id') }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the parameter IS a User class' do
      it 'returns the user itself' do
        expect(described_class.retrieve_person(user_a)).to eq user_a
      end
    end
  end
end
