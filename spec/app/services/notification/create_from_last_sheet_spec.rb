require 'rails_helper'

RSpec.describe Notification::CreateFromLastSheet do
  describe ".call" do
    subject(:call) { described_class.call }

    let!(:first_sheet) { create(:sheet, created_at: 1.hour.ago) }
    let!(:last_sheet) { create(:sheet, title: "test123") }

    around do |example|
      VCR.use_cassette('Google::Sheet::MapData.sheet_contains_valid_data') do
        example.run
      end
    end

    it "maps data from last sheet" do
      expect(Sheet::MapData).to receive(:call)
        .with(last_sheet)
        .and_call_original

      call
    end
  end
end
