require 'rails_helper'

RSpec.describe Google::Sheet::SendImportReports do
  describe '.call' do
    subject(:call) { described_class.call(sheet, import_reports) }

    let(:spreadsheet_id) { ENV['SPREADSHEET_ID'] }
    let(:sheet) { create(:sheet, title: title) }

    context 'when there are import reports' do
      let(:title) { 'test123' }
      let(:range_with_sheet) { "#{sheet.title}!#{range}" }
      let(:range) { 'I2' }
      let(:import_reports) do
        [
          Google::Sheet::Data::RowImportReport.new(
            imported: true,
            index: 1,
            errors: []
          )
        ]
      end
      let(:sent_data) { { values: [['TAK']] } }

      around do |example|
        VCR.use_cassette('Google::Sheet::SendImportReports.with_imported_reports') do
          example.run
        end
      end

      it 'sends reports to google sheet' do
        call

        assert_requested :put, "https://sheets.googleapis.com/v4/spreadsheets/#{spreadsheet_id}/values/#{range_with_sheet}?valueInputOption=RAW" do |request|
          expect(JSON.parse(request.body).deep_symbolize_keys).to eq sent_data
        end
      end
    end

    context 'when there are not import reports' do
      let(:title) { 'test123' }
      let(:range_with_sheet) { "#{sheet.title}!#{range}" }
      let(:range) { 'I2' }
      let(:import_reports) do
        []
      end

      it 'does not send reports to google sheet' do
        call

        assert_not_requested :put, "https://sheets.googleapis.com/v4/spreadsheets/#{spreadsheet_id}/values/#{range_with_sheet}?valueInputOption=RAW"
      end
    end
  end
end
