class Google::Sheet::RemoveProcessedNotifications
  include StatelessService

  initialize_with :sheet_data, :sheet

  IMPORT_REPORT_COLUMN = 8
  COLUMNS_WITH_DATA = 10
  FIRST_CELL_WITH_DATA = 'A2'.freeze

  private_constant :IMPORT_REPORT_COLUMN, :COLUMNS_WITH_DATA, :FIRST_CELL_WITH_DATA

  dependencies do
    {
      google_sheet_api: Google::Sheet::API.new
    }
  end

  def call
    return if sheet_data.empty?
    return if all_notifiactions_are_not_processed?

    remove_processed_notifications
  end

  private

  def remove_processed_notifications
    data = prepare_request_data

    google_sheet_api.write(sheet.title, FIRST_CELL_WITH_DATA, data)
  end

  def prepare_request_data
    rows_quantity = sheet_data.count - not_processed_notifications.count

    empty_rows_for_overriding_processed_data = Array.new(
      rows_quantity,
      Array.new(COLUMNS_WITH_DATA, '')
    )

    not_processed_notifications.concat(empty_rows_for_overriding_processed_data)
  end

  def not_processed_notifications
    @not_processed_notifications ||= sheet_data[1..].select do |row|
      row[IMPORT_REPORT_COLUMN] == false_text
    end
  end

  def all_notifiactions_are_not_processed?
    sheet_data[1..].all? { |row| row[IMPORT_REPORT_COLUMN] == false_text }
  end

  def false_text
    I18n.t('sheet.no_text')
  end
end
