require 'rails_helper'

RSpec.describe Sheet::MapData do
  describe '.call' do
    subject(:call) { described_class.call(sheet) }

    let(:sheet) { create(:sheet, title: title) }
    let(:spreadsheet_id) { ENV['SPREADSHEET_ID'] }

    around do |example|
      VCR.use_cassette(cassette_name) do
        example.run
      end
    end

    context 'when sheet exists' do
      context 'when sheet contains valid data' do
        let(:cassette_name) { 'Google::Sheet::MapData.sheet_contains_valid_data' }
        let(:title) { 'test123' }
        let(:range_with_sheet) { "#{sheet.title}!#{range}" }
        let(:range) { 'I2' }
        let(:valid_report) { { values: [['TAK'], ['TAK']] } }

        it 'posts auth requests when read data and write report' do
          call

          assert_requested :post, 'https://www.googleapis.com/oauth2/v4/token'
        end

        it 'imports notifications' do
          expect { call }.to change { Notification.count }.by(2)
        end

        it 'gets data from google api' do
          call

          assert_requested :get, "https://sheets.googleapis.com/v4/spreadsheets/#{spreadsheet_id}/values/#{sheet.title}"
        end

        it 'puts data with report' do
          call

          assert_requested :put, "https://sheets.googleapis.com/v4/spreadsheets/#{spreadsheet_id}/values/#{range_with_sheet}?valueInputOption=RAW" do |request|
            expect(JSON.parse(request.body).deep_symbolize_keys).to eq valid_report
          end
        end
      end

      context 'when sheet contains invalid data' do
        let(:cassette_name) { 'Google::MapSheetData.sheet_contains_invalid_data' }
        let(:title) { 'test123' }
        let(:range_with_sheet) { "#{sheet.title}!#{range}" }
        let(:range) { 'I2' }
        let(:invalid_report) do
          { values: [['NIE', 'Termin płatności nie może być puste, Powiadomienie jest nieprawidłowe']] }
        end

        it 'puts data with report with invalid data info' do
          call

          assert_requested :put, "https://sheets.googleapis.com/v4/spreadsheets/#{spreadsheet_id}/values/#{range_with_sheet}?valueInputOption=RAW" do |request|
            expect(JSON.parse(request.body).deep_symbolize_keys).to eq invalid_report
          end
        end

        it 'does not create notifications' do
          expect { call }.not_to(change { Notification.count })
        end
      end

      context 'when sheet contains imported rows' do
        let(:cassette_name) { 'Google::MapSheetData.sheet_contains_imported_data' }
        let(:title) { 'test123' }
        let(:range_with_sheet) { "#{sheet.title}!#{range}" }
        let(:range) { 'I2' }

        it 'does not import anything' do
          call

          assert_not_requested :put, "https://sheets.googleapis.com/v4/spreadsheets/#{spreadsheet_id}/values/#{range_with_sheet}?valueInputOption=RAW"
        end

        it 'does not create notifications' do
          expect { call }.not_to(change { Notification.count })
        end
      end
    end

    context 'when sheet does not exist' do
      let(:title) { 'some_not_existed_sheet' }
      let(:cassette_name) { 'Google::Sheet::MapData.sheet_does_not_exist' }

      it 'raises exceptions' do
        expect { call }.to raise_exception(Google::Apis::ClientError)
      end
    end
  end
end
