require 'rails_helper'

RSpec.describe Notification::Send do
  describe '.call' do
    subject(:call) { described_class.call }
    let!(:customer) { create(:customer) }

    context 'when notifications are ready to be sent' do
      let!(:notification) { create(:notification, customer: customer) }

      it 'sends a notification' do
        expect { call }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'updates delivered_at attribute' do
        expect { call }.to change { notification.reload.delivered_at }.from(nil).to(Date.today)
      end
    end

    context 'when customer does not have any notification' do
      it 'does not send any notification' do
        expect { call }.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end

    context 'when notification is not ready to be sent' do
      let!(:notification) { create(:notification, customer: customer, send_at: Date.tomorrow) }

      it 'does not send any notification' do
        expect { call }.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end
end
