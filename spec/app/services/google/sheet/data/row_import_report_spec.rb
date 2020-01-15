require 'rails_helper'

RSpec.describe Google::Sheet::Data::RowImportReport do
  describe '#to_report_data' do
    subject(:to_report_data) do
      described_class.new(imported: imported, errors: errors, index: 1).to_report_data
    end

    let(:errors) { %w[example error] }

    context 'when imported is true' do
      let(:imported) { true }

      it { is_expected.to eq ['TAK'] }
    end

    context 'when imported is false' do
      let(:imported) { false }

      it { is_expected.to eq ['NIE', 'example, error'] }
    end
  end
end
