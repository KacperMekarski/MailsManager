class NotificationMailer < ApplicationMailer
  default from: 'biuro@3-tax.com'

  def send_zus
    @notification = params[:notification]
    return unless @notification

    subject = I18n.t('notification_mailer.zus_for', period: @notification.period)
    mail(to: @notification.customer.email, subject: subject)
  end
end
