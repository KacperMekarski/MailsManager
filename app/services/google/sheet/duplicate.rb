class Google::Sheet::Duplicate
  include StatelessService

  dependencies do
    {
      google_sheet_api: Google::Sheet::API.new
    }
  end

  initialize_with :sheet, :new_sheet_name

  def call
    response = duplicate_google_sheet

    prepare_new_sheet_data_from_response(response)
  end

  private

  def duplicate_google_sheet
    google_sheet_api.duplicate(sheet.sheet_id.to_s, new_sheet_name)
  end

  def prepare_new_sheet_data_from_response(response)
    properties = response.replies.first.duplicate_sheet.properties

    {
      sheet_id: properties.sheet_id.to_s,
      title: properties.title
    }
  end
end
