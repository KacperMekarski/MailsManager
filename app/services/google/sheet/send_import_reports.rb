class Google::Sheet::SendImportReports
  include StatelessService

  dependencies do
    {
      google_sheet_api: Google::Sheet::API.new
    }
  end

  REPORT_COLUMN = 'I'.freeze
  private_constant :REPORT_COLUMN

  initialize_with :sheet, :import_reports

  def call
    send_report_data
  end

  private

  def send_report_data
    return if import_reports.empty?

    google_sheet_api.write(sheet.title, first_report_row, report_data)
  end

  def report_data
    @report_data ||= (min_index..max_index).map do |row_index|
      convert_to_report_data(reports_by_index[row_index])
    end
  end

  def convert_to_report_data(report)
    report.nil? ? '' : report.to_report_data
  end

  def max_index
    @max_index ||= import_reports.max_by(&:index)&.index
  end

  def min_index
    @min_index ||= import_reports.min_by(&:index)&.index
  end

  def first_report_row
    @first_report_row ||= [REPORT_COLUMN, min_index + 1].join
  end

  def reports_by_index
    @reports_by_index ||= import_reports.index_by(&:index)
  end
end
