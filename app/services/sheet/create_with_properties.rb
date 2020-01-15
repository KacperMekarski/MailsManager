class Sheet::CreateWithProperties
  include StatelessService

  initialize_with :sheet_properties

  def call
    ::Sheet.create!(sheet_properties)
  end
end
