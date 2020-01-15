# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  SHEET_ID = 3_214_859_238
  TAX_AMOUNT = 120
  DATE = '2019-09'.freeze

  def send_zus
    NotificationMailer.with(customer: customer, notification: notification).send_zus
  end

  private

  def customer
    @customer ||= Customer.create!(
      email: 'kacper@email.com',
      fullname: 'Kacper Mękarski'
    )
  end

  def sheet
    @sheet ||= Sheet.create!(
      sheet_id: SHEET_ID,
      title: 'Sheet title'
    )
  end

  def notification
    @notification ||= Notification.create!(
      send_at: DateTime.now,
      read_at: DateTime.now,
      payment_deadline_on: Date.today,
      period: DATE,
      tax_amount: TAX_AMOUNT,
      customer_id: customer.id,
      sheet_id: sheet.id
    )
  end
end
