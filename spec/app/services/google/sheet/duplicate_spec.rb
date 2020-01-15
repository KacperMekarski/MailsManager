require 'rails_helper'

RSpec.describe Google::Sheet::Duplicate do
  describe '.call' do
    subject(:call) { described_class.call(sheet, new_sheet_title) }

    let(:sheet) { create(:sheet, sheet_id: sheet_id) }

    around do |example|
      VCR.use_cassette(cassette_name) do
        example.run
      end
    end

    context 'when sheet exists with passed id' do
      let(:cassette_name) { 'Google::Sheet::Duplicate.sheet_exists' }
      let(:sheet_id) { '704988061' }

      context 'when new sheet name uniq' do
        let(:new_sheet_title) { 'test_sheet_name_duplicate' }

        it 'duplicates google sheet' do
          expect_any_instance_of(Google::Sheet::API).to receive(:duplicate)
            .with(sheet_id, new_sheet_title).and_call_original

          call
        end

        it 'returns new sheet properties' do
          expect(call).to eq(
            sheet_id: '1593491830',
            title: new_sheet_title
          )
        end
      end

      context 'when new sheet name is duplicated' do
        let(:cassette_name) { 'Google::Sheet::Duplicate.sheet_exists.duplicated' }
        let(:new_sheet_title) { 'test_sheet_name_duplicate' }

        it 'raises exception' do
          expect { call }.to raise_exception(Google::Apis::ClientError)
        end
      end
    end

    context 'when sheet does not exist with passed id' do
      let(:cassette_name) { 'Google::Sheet::Duplicate.sheet_does_not_exist' }
      let(:new_sheet_title) { 'test_sheet_name_duplicates' }
      let(:sheet_id) { '704988062' }

      it 'raises exception' do
        expect { call }.to raise_exception(Google::Apis::ClientError)
      end
    end
  end
end
