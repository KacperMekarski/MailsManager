module Google::Sheet::API::Base
  def service
    @service ||= Google::Sheet::ServiceFactory.build
  end

  def spreadsheet_id
    ENV.fetch('SPREADSHEET_ID')
  end
end
