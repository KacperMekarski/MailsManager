module Google::Sheet::API::Duplicate
  def duplicate(sheet_id, new_sheet_name)
    service.batch_update_spreadsheet(
      spreadsheet_id,
      duplicate_request_body(sheet_id, new_sheet_name),
      {}
    )
  end

  private

  def duplicate_request_body(sheet_id, new_sheet_name)
    {
      requests: [
        {
          duplicate_sheet: {
            source_sheet_id: sheet_id,
            insert_sheet_index: 0,
            new_sheet_name: new_sheet_name
          }
        }
      ]
    }
  end
end
