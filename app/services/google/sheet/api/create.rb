module Google::Sheet::API::Create
  def create(sheet_name)
    service.batch_update_spreadsheet(
      spreadsheet_id,
      create_request_body(sheet_name),
      {}
    )
  end

  private

  def create_request_body(sheet_name)
    {
      requests: [
        {
          add_sheet: {
            properties: {
              index: 0,
              title: sheet_name
            }
          }
        }
      ]
    }
  end
end
