module Google::Sheet::API::Read
  def read(sheet_title)
    range = sheet_title

    service.get_spreadsheet_values(
      spreadsheet_id,
      range
    ).values || []
  end
end
