require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    subject(:customer) { create(:customer) }

    it { is_expected.to validate_presence_of(:fullname) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to allow_value('some@email.com').for(:email) }
    it { is_expected.not_to allow_value('some@email').for(:email) }
    it { is_expected.not_to allow_value('some$email.com').for(:email) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:notifications) }
  end
end
