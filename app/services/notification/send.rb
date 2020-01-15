class Notification::Send
  include StatelessService

  def call
    Notification.past.not_delivered.each do |notification|
      NotificationMailer.with(notification: notification).send_zus.deliver_now
      notification.update(delivered_at: Date.today)
    end
  end
end
