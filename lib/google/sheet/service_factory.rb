class Google::Sheet::ServiceFactory
  include StatelessService

  READ_WRITE_SCOPE = 'https://www.googleapis.com/auth/spreadsheets'.freeze
  private_constant :READ_WRITE_SCOPE

  call_via :build

  def build
    build_api_service
  end

  private

  def build_api_service
    Google::Apis::SheetsV4::SheetsService.new.tap do |service|
      service.authorization = authorization
    end
  end

  def authorization
    ::Google::Auth::ServiceAccountCredentials.make_creds(scope: READ_WRITE_SCOPE)
  end
end
