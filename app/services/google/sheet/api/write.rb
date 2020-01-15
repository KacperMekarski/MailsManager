module Google::Sheet::API::Write
  # range should be in format 'A1' or 'A1:D5'
  def write(sheet_title, range, data)
    range_with_sheet = "#{sheet_title}!#{range}"
    data_object = Google::Apis::SheetsV4::ValueRange.new(values: data)

    service.update_spreadsheet_value(
      spreadsheet_id,
      range_with_sheet,
      data_object,
      value_input_option: 'RAW'
    )
  end
end
