require 'rails_helper'

RSpec.describe Google::Sheet::RemoveProcessedNotifications do
  describe '.call' do
    subject(:call) { described_class.call(sheet_data, sheet) }

    let!(:sheet) { create(:sheet, title: title, sheet_id: sheet_id) }
    let(:sheet_id) { '65308070' }
    let(:title) { 'test_sheet' }

    around do |example|
      VCR.use_cassette(cassette_name) do
        example.run
      end
    end

    context 'when sheet exists' do
      let(:cassette_name) { 'Google::Sheet::RemoveProcessedNotifications.call' }
      let(:spreadsheet_id) { ENV['SPREADSHEET_ID'] }
      let(:range) { "#{title}!A2" }

      context 'when sheet data contains processed and not processed notifications' do
        let(:sheet_data) do
          [
            ['email', 'imię i nazwisko', 'termin płatności', 'okres', 'kwota', 'data wysyłki maila', 'dostarczono?', 'odczytano?', 'zaimportowano?', 'błędy'],
            ['example2@mail.com', 'test2', '2019-12-29', '2019-10', '1', '2019-10-15', '', '', 'TAK'],
            ['', '', '', '', '', '', '', '', 'NIE', 'Tax amount nie może być puste, Period nie może być puste, Termin płatności nie może być puste, Fullname nie może być puste, Email nie może być puste, Email jest nieprawidłowe, Powiadomienie jest nieprawidłowe'],
            ['example3@mail.com', 'test2', '2019-12-29', '2019-10', '1', '2019-10-15', '', '', 'TAK'],
            ['example4@mail.com', 'test2', '2019-12-29', '2019-10', '1', '2019-10-15', '', '', 'TAK']
          ]
        end
        let(:expected_payload) do
          {
            values: [
              ['', '', '', '', '', '', '', '', 'NIE', 'Tax amount nie może być puste, Period nie może być puste, Termin płatności nie może być puste, Fullname nie może być puste, Email nie może być puste, Email jest nieprawidłowe, Powiadomienie jest nieprawidłowe'],
              ['', '', '', '', '', '', '', '', '', ''],
              ['', '', '', '', '', '', '', '', '', ''],
              ['', '', '', '', '', '', '', '', '', ''],
              ['', '', '', '', '', '', '', '', '', '']
            ]
          }
        end

        it 'overrides only processed sheet data' do
          call

          assert_requested :put, "https://sheets.googleapis.com/v4/spreadsheets/#{spreadsheet_id}/values/#{range}?valueInputOption=RAW" do |request|
            expect(JSON.parse(request.body).deep_symbolize_keys).to eq expected_payload
          end
        end
      end

      context 'when sheet data contain only processed notifications' do
        let(:sheet_data) do
          [
            ['email', 'imię i nazwisko', 'termin płatności', 'okres', 'kwota', 'data wysyłki maila', 'dostarczono?', 'odczytano?', 'zaimportowano?', 'błędy'],
            ['example2@mail.com', 'test2', '2019-12-29', '2019-10', '1', '2019-10-15', '', '', 'TAK'],
            ['example3@mail.com', 'test2', '2019-12-29', '2019-10', '1', '2019-10-15', '', '', 'TAK'],
            ['example4@mail.com', 'test2', '2019-12-29', '2019-10', '1', '2019-10-15', '', '', 'TAK']
          ]
        end
        let(:expected_payload) do
          {
            values: [
              ['', '', '', '', '', '', '', '', '', ''],
              ['', '', '', '', '', '', '', '', '', ''],
              ['', '', '', '', '', '', '', '', '', ''],
              ['', '', '', '', '', '', '', '', '', '']
            ]
          }
        end

        it 'overrides all sheet data' do
          call

          assert_requested :put, "https://sheets.googleapis.com/v4/spreadsheets/#{spreadsheet_id}/values/#{range}?valueInputOption=RAW" do |request|
            expect(JSON.parse(request.body).deep_symbolize_keys).to eq expected_payload
          end
        end
      end

      context 'when sheet data contain only not processed notifications' do
        let(:sheet_data) do
          [
            ['email', 'imię i nazwisko', 'termin płatności', 'okres', 'kwota', 'data wysyłki maila', 'dostarczono?', 'odczytano?', 'zaimportowano?', 'błędy'],
            ['', '', '', '', '', '', '', '', 'NIE', 'Tax amount nie może być puste'],
            ['', '', '', '', '', '', '', '', 'NIE', 'Tax amount nie może być puste'],
            ['', '', '', '', '', '', '', '', 'NIE', 'Tax amount nie może być puste']
          ]
        end

        it 'does not override sheet data' do
          call

          assert_not_requested :put, "https://sheets.googleapis.com/v4/spreadsheets/#{spreadsheet_id}/values/#{range}?valueInputOption=RAW"
        end
      end

      context 'when sheet data are empty' do
        let(:sheet_data) { [] }

        it 'does not override sheet data' do
          call

          assert_not_requested :put, "https://sheets.googleapis.com/v4/spreadsheets/#{spreadsheet_id}/values/#{range}?valueInputOption=RAW"
        end
      end
    end

    context 'when sheet does not exist' do
      let(:cassette_name) { 'Google::Sheet::RemoveProcessedNotifications.call.error' }
      let(:spreadsheet_id) { ENV['SPREADSHEET_ID'] }
      let(:range) { "#{title}!A2" }
      let(:title) { 'not_existing_sheet' }
      let(:sheet_data) do
        [
          ['email', 'imię i nazwisko', 'termin płatności', 'okres', 'kwota', 'data wysyłki maila', 'dostarczono?', 'odczytano?', 'zaimportowano?', 'błędy'],
          ['example2@mail.com', 'test2', '2019-12-29', '2019-10', '1', '2019-10-15', '', '', 'TAK'],
          ['', '', '', '', '', '', '', '', 'NIE', 'Tax amount nie może być puste, Period nie może być puste, Termin płatności nie może być puste, Fullname nie może być puste, Email nie może być puste, Email jest nieprawidłowe, Powiadomienie jest nieprawidłowe'],
          ['example3@mail.com', 'test2', '2019-12-29', '2019-10', '1', '2019-10-15', '', '', 'TAK'],
          ['example4@mail.com', 'test2', '2019-12-29', '2019-10', '1', '2019-10-15', '', '', 'TAK']
        ]
      end

      it 'raises exception' do
        expect { call }.to raise_exception(Google::Apis::ClientError)
      end
    end
  end
end
