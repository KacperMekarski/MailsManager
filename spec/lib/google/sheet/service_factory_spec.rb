require 'rails_helper'

RSpec.describe Google::Sheet::ServiceFactory do
  describe '.build' do
    subject(:build) { described_class.build }

    it 'builds service' do
      expect(build).to be_a Google::Apis::SheetsV4::SheetsService
    end
  end
end
