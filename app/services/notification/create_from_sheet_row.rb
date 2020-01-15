class Notification::CreateFromSheetRow
  include StatelessService

  NOTIFICATION_ATTRIBUTES = {
    payment_deadline_on: 2,
    period: 3,
    tax_amount: 4,
    send_at: 5
  }.freeze
  private_constant :NOTIFICATION_ATTRIBUTES

  initialize_with :row, :sheet

  def call
    Notification.transaction do
      create_notification
    end
  end

  private

  def create_notification
    customer
      .notifications
      .build(notification_attributes)
      .tap { customer.save }
  end

  def notification_attributes
    attributes = NOTIFICATION_ATTRIBUTES.map do |attribute, index|
      [attribute, row[index]]
    end.to_h

    attributes.tap do |attrs|
      attrs[:sheet] = sheet
    end
  end

  def customer
    @customer ||= Customer::FindOrInitializeFromSheetData.call(row)
  end
end
