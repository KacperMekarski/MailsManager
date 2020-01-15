require 'rails_helper'

RSpec.describe Notification::CreateFromSheetRow do
  describe '.call' do
    subject(:call) { described_class.call(row, sheet) }

    let(:sheet) { create(:sheet) }

    context 'when data are valid' do
      context 'when customer exists' do
        let!(:customer) { create(:customer, fullname: fullname, email: email) }
        let(:fullname) { Faker::Name.name }
        let(:email) { Faker::Internet.email }

        let(:row) { [email, fullname, '2019-10-23', '2019-10', '10000', '2019-10-15'] }

        it 'creates notification' do
          expect { call }.to change { Notification.count }.by(1)
        end

        it 'creates notification with proper data' do
          notification = call

          expect(notification.customer).to eq(customer)
          expect(notification.tax_amount).to eq(10_000)
          expect(notification.sheet).to eq(sheet)
          expect(notification.period).to eq('2019-10')
          expect(notification.payment_deadline_on).to eq('2019-10-23'.to_date)
          expect(notification.send_at).to eq('2019-10-15'.to_date)
        end
      end

      context 'when customer does not exist' do
        let(:customer) { Customer.last }
        let(:fullname) { Faker::Name.name }
        let(:email) { Faker::Internet.email }

        let(:row) { [email, fullname, '2019-10-23', '2019-10', '10000', '2019-10-15'] }

        it 'creates notification' do
          expect { call }.to change { Notification.count }.by(1)
        end

        it 'creates notification with proper data' do
          notification = call

          expect(notification.customer).to eq(customer)
          expect(notification.tax_amount).to eq(10_000)
          expect(notification.sheet).to eq(sheet)
          expect(notification.period).to eq('2019-10')
          expect(notification.payment_deadline_on).to eq('2019-10-23'.to_date)
          expect(notification.send_at).to eq('2019-10-15'.to_date)
        end

        it 'creates customer' do
          expect { call }.to change { Customer.count }.by(1)
        end

        it 'creates customer with proper data' do
          call

          expect(customer.fullname).to eq fullname
          expect(customer.email).to eq email
        end
      end
    end

    context 'when data are invalid' do
      context 'when customer data are invalid' do
        let(:row) { ['', 'fullname', '2019-10-23', '2019-10', '10000', '2019-10-15'] }

        it 'does not creates notification' do
          expect { call }.not_to(change { Notification.count })
        end

        it 'does not creates customer' do
          expect { call }.not_to(change { Customer.count })
        end
      end

      context 'when notification data are invalid' do
        let(:row) { [email, 'fullname', '2019-10-23', '2019-10', '', '2019-10-15'] }
        let(:email) { Faker::Internet.email }

        it 'does not creates notification' do
          expect { call }.not_to(change { Notification.count })
        end

        it 'does not creates customer' do
          expect { call }.not_to(change { Customer.count })
        end
      end
    end
  end
end
