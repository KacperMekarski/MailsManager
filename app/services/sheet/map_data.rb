class Sheet::MapData
  include StatelessService

  dependencies do
    {
      google_sheet_api: Google::Sheet::API.new
    }
  end

  HEADERS_ROW = 0
  IMPORT_REPORT_COLUMN = 8
  private_constant :HEADERS_ROW, :IMPORT_REPORT_COLUMN

  initialize_with :sheet

  def call
    sheet_data.each_with_index { |row, index| process_row(row, index) }
    send_import_reports
  end

  private

  def process_row(row, index)
    return if index == HEADERS_ROW
    return if row_processed?(row)

    notification = create_notification(row)
    add_import_report(notification, index)
  end

  def row_processed?(row)
    row[IMPORT_REPORT_COLUMN].present?
  end

  def send_import_reports
    Google::Sheet::SendImportReports.call(sheet, import_reports) if import_reports.any?
  end

  def create_notification(row)
    Notification::CreateFromSheetRow.call(row, sheet)
  end

  def sheet_data
    @sheet_data ||= google_sheet_api.read(sheet.title)
  end

  def import_reports
    @import_reports ||= []
  end

  def add_import_report(notification, index)
    customer = notification.customer
    imported = notification.valid? && customer.valid?
    errors = notification.errors.to_a + customer.errors.to_a

    import_reports << Google::Sheet::Data::RowImportReport.new(
      imported: imported,
      index: index,
      errors: errors
    )
  end
end
