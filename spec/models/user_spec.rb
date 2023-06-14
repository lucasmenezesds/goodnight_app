# frozen_string_literal: true

require 'rails_helper'

describe User do
  context 'when creating users' do
    it 'doesnt allow creating with empty name' do
      expect { described_class.create!(name: '') }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
    end

    it 'created the user successfully' do
      expect { described_class.create(name: Faker::Name.name) }.to change(described_class, :count).by(1)
    end
  end

  context 'when checking paranoia' do
    let(:user) { create(:user) }

    it 'doesnt return the user after same is deleted' do
      expect(described_class.find_by(id: user.id)).not_to be_nil
      user.update(deleted_at: Time.zone.now)
      expect(described_class.find_by(id: user.id)).to be_nil
    end
  end
end
