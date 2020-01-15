require 'rails_helper'

RSpec.describe Google::Sheet::API do
  describe '#create' do
    subject(:create) { described_class.new.create(sheet_title) }

    let(:spreadsheet_id) { ENV['SPREADSHEET_ID'] }
    let(:sheet_title) { '2019-10-09' }
    let(:create_payload) do
      {
        requests: [
          {
            addSheet: {
              properties: { index: 0, title: sheet_title }
            }
          }
        ]
      }
    end

    around do |example|
      VCR.use_cassette('Google::Sheet::Create') do
        example.run
      end
    end

    it 'posts auth request' do
      create

      assert_requested :post, 'https://www.googleapis.com/oauth2/v4/token'
    end

    it 'posts data to google api' do
      create

      assert_requested :post, "https://sheets.googleapis.com/v4/spreadsheets/#{spreadsheet_id}:batchUpdate" do |request|
        expect(JSON.parse(request.body).deep_symbolize_keys).to eq create_payload
      end
    end

    context 'when sheet already exists with this name' do
      around do |example|
        VCR.use_cassette('Google::Sheet::Create_error') do
          example.run
        end
      end

      it 'raises exception' do
        expect { create }.to raise_exception(Google::Apis::ClientError)
      end
    end
  end

  describe '#duplicate' do
    subject(:duplicate) { described_class.new.duplicate(sheet_id, new_sheet_title) }

    let(:sheet_id) { 891_351_933 }
    let(:spreadsheet_id) { ENV['SPREADSHEET_ID'] }
    let(:new_sheet_title) { 'duplicated sheet title' }
    let(:duplicate_payload) do
      {
        requests: [
          {
            duplicateSheet: {
              insertSheetIndex: 0,
              newSheetName: new_sheet_title,
              sourceSheetId: sheet_id
            }
          }
        ]
      }
    end

    around do |example|
      VCR.use_cassette('Google::Sheet::Duplicate') do
        example.run
      end
    end

    it 'posts auth request' do
      duplicate

      assert_requested :post, 'https://www.googleapis.com/oauth2/v4/token'
    end

    it 'post data to google api' do
      duplicate

      assert_requested :post, "https://sheets.googleapis.com/v4/spreadsheets/#{spreadsheet_id}:batchUpdate" do |request|
        expect(JSON.parse(request.body).deep_symbolize_keys).to eq(duplicate_payload)
      end
    end

    context 'when sheet already exists with this name' do
      around do |example|
        VCR.use_cassette('Google::Sheet::Duplicate_error') do
          example.run
        end
      end

      it 'raises exception' do
        expect { duplicate }.to raise_exception(Google::Apis::ClientError)
      end
    end
  end

  describe '#read' do
    subject(:read) { described_class.new.read(sheet_title) }

    let(:sheet_title) { 'test_sheet' }
    let(:spreadsheet_id) { ENV['SPREADSHEET_ID'] }

    around do |example|
      VCR.use_cassette('Google::Sheet::ReadSheet') do
        example.run
      end
    end

    it 'posts auth request' do
      read

      assert_requested :post, 'https://www.googleapis.com/oauth2/v4/token'
    end

    it 'gets data from google api' do
      read

      assert_requested :get, "https://sheets.googleapis.com/v4/spreadsheets/#{spreadsheet_id}/values/#{sheet_title}"
    end

    it 'returns array with rows' do
      expect(read).to be_an Array
    end
  end

  describe '#write' do
    subject(:write) { described_class.new.write(sheet_title, range, data) }

    let(:sheet_title) { 'test123' }
    let(:range) { 'A1' }
    let(:data) { [%w[first second], %w[xx zz]] }
    let(:range_with_sheet) { "#{sheet_title}!#{range}" }
    let(:spreadsheet_id) { ENV['SPREADSHEET_ID'] }
    let(:write_payload) { { values: [%w[first second], %w[xx zz]] } }

    around do |example|
      VCR.use_cassette('Google::Sheet::Write') do
        example.run
      end
    end

    it 'puts data to google_api' do
      write

      assert_requested :put, "https://sheets.googleapis.com/v4/spreadsheets/#{spreadsheet_id}/values/#{range_with_sheet}?valueInputOption=RAW" do |request|
        expect(JSON.parse(request.body).deep_symbolize_keys).to eq write_payload
      end
    end

    it 'posts auth request' do
      write

      assert_requested :post, 'https://www.googleapis.com/oauth2/v4/token'
    end

    context 'when passed data are incorect' do
      let(:sheet_title) { 'wrong title' }

      around do |example|
        VCR.use_cassette('Google::Sheet::Write.error') do
          example.run
        end
      end

      it 'raises exception' do
        expect { write }.to raise_exception(Google::Apis::ClientError)
      end
    end
  end
end
