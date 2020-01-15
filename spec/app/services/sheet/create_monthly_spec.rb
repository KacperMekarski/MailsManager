require 'rails_helper'

RSpec.describe Sheet::CreateMonthly, freeze_time: '2020-01-12' do
  describe '.call' do
    subject(:call) { described_class.call }

    let!(:sheet) { create(:sheet, title: title, sheet_id: sheet_id) }
    let(:sheet_id) { '65308070' }
    let(:title) { 'test_sheet' }
    let(:last_sheet) { Sheet.last }
    let(:current_month_stamp) { "ZUS #{Time.current.strftime('%Y-%m')}" }

    around do |example|
      VCR.use_cassette(cassette_name) do
        example.run
      end
    end

    context 'when sheet exists' do
      let(:cassette_name) { 'Google::Sheet::CreateMonthly.call' }
      let(:last_sheet_data) do
        [
          ['email', 'imię i nazwisko', 'termin płatności', 'okres', 'kwota', 'data wysyłki maila', 'dostarczono?', 'odczytano?', 'zaimportowano?', 'błędy'],
          ['example2@mail.com', 'test2', '2019-12-29', '2019-10', '1', '2019-10-15', '', '', 'TAK'],
          [],
          ['example3@mail.com', 'test2', '2019-12-29', '2019-10', '1', '2019-10-15', '', '', 'TAK'],
          ['example4@mail.com', 'test2', '2019-12-29', '2019-10', '1', '2019-10-15', '', '', 'TAK']
        ]
      end

      it 'does not raise exception' do
        expect { call }.not_to raise_exception
      end

      it 'creates new sheet' do
        expect { call }.to change { Sheet.count }.by(1)
      end

      it 'sets proper sheet title' do
        call

        expect(last_sheet.title).to eq current_month_stamp
      end

      it 'duplicates sheet in google spreadsheet' do
        expect(Google::Sheet::Duplicate)
          .to receive(:call).with(last_sheet, current_month_stamp)
                            .and_call_original

        call
      end

      it 'remove processed notifications' do
        expect(Google::Sheet::RemoveProcessedNotifications)
          .to receive(:call).with(last_sheet_data, instance_of(::Sheet))
                            .and_call_original

        call
      end
    end

    context 'when sheet does not exists' do
      let(:cassette_name) { 'Google::Sheet::MapData.sheet_does_not_exist' }

      let(:title) { 'some_not_existed_sheet' }

      it 'raises exception' do
        expect { call }.to raise_exception(Google::Apis::ClientError)
      end
    end
  end
end
