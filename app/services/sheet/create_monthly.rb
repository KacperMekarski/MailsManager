class Sheet::CreateMonthly
  include StatelessService

  dependencies do
    {
      google_sheet_api: Google::Sheet::API.new
    }
  end

  def call
    last_sheet_data = read_sheet_data(last_sheet)
    sheet_properties = duplicate_sheet

    duplicated_sheet = Sheet::CreateWithProperties.call(sheet_properties)
    remove_processed_notifications(last_sheet_data, duplicated_sheet)
  end

  private

  def remove_processed_notifications(last_sheet_data, duplicated_sheet)
    Google::Sheet::RemoveProcessedNotifications.call(last_sheet_data, duplicated_sheet)
  end

  def duplicate_sheet
    Google::Sheet::Duplicate.call(last_sheet, new_sheet_name)
  end

  def new_sheet_name
    "ZUS #{Time.current.strftime('%Y-%m')}"
  end

  def last_sheet
    ::Sheet.last
  end

  def read_sheet_data(sheet)
    google_sheet_api.read(sheet.title)
  end
end
