require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:tax_amount) }
    it { is_expected.to validate_presence_of(:customer) }
    it { is_expected.to validate_presence_of(:sheet) }
    it { is_expected.to validate_presence_of(:period) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to belong_to(:sheet) }
  end

  describe 'scopes' do
    describe '.past' do
      subject(:past) { described_class.past }

      context 'when notification is from past' do
        let!(:notification) { create(:notification, send_at: 1.month.ago) }

        it 'returns that notification' do
          expect(past).to match_array([notification])
        end
      end

      context 'when notification is from today' do
        let!(:notification) { create(:notification, send_at: Date.today) }

        it 'returns that notification' do
          expect(past).to match_array([notification])
        end
      end

      context 'when notification is in future' do
        let!(:notification) { create(:notification, send_at: Date.today.next_month) }

        it 'returns empty array' do
          expect(past).to be_empty
        end
      end
    end

    describe '.not_delivered' do
      subject(:not_delivered) { described_class.not_delivered }

      context 'when notification is delivered' do
        let!(:notification) { create(:notification, delivered_at: 1.day.ago) }

        it 'returns empty array' do
          expect(not_delivered).to be_empty
        end
      end

      context 'when notification is not delivered' do
        let!(:notification) { create(:notification) }

        it 'returns notification' do
          expect(not_delivered).to match_array([notification])
        end
      end
    end
  end
end
