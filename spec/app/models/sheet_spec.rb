require 'rails_helper'

RSpec.describe Sheet, type: :model do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:sheet_id) }

    describe 'relations' do
      it { is_expected.to have_many(:notifications) }
    end
  end
end
