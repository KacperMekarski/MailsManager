require 'rails_helper'

RSpec.describe Customer::FindOrInitializeFromSheetData do
  describe '.call' do
    subject(:call) { described_class.call(row) }

    let(:row) { [email, fullname] }
    let(:email) { 'some@email.com' }
    let(:fullname) { 'fullname' }

    context 'when customer does not exist' do
      it { is_expected.to be_a Customer }

      it 'is not persisted' do
        expect(call.persisted?).to eq false
      end
    end

    context 'when customer exists' do
      let!(:customer) { create(:customer, email: email, fullname: fullname) }

      it { is_expected.to be_a Customer }

      it 'is persisted' do
        expect(call.persisted?).to eq true
      end
    end
  end
end
