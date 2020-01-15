require 'rails_helper'

RSpec.describe NotificationMailer, type: :mailer do
  describe 'customer mailer' do
    let(:notification) { create(:notification) }
    let(:customer) { notification.customer }
    let(:mail) do
      described_class.with(
        notification: customer.notifications.last,
        customer: customer
      ).send_zus.deliver_now
    end

    it 'renders the subject' do
      subject = 'ZUS za ' + notification.period
      expect(mail.subject).to eq(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([customer.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['biuro@3-tax.com'])
    end

    it 'assigns @confirmation_url' do
      expect(mail.body.encoded)
        .to match(/3-Tax/)
    end
  end
end
