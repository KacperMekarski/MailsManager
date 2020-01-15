class Google::Sheet::Data::RowImportReport < Dry::Struct
  attribute :imported, Types::Strict::Bool
  attribute :errors, Types::Strict::Array
  attribute :index, Types::Strict::Int

  def to_report_data
    imported ? [true_text] : [false_text, errors.join(', ')]
  end

  private

  def true_text
    I18n.t('sheet.yes_text')
  end

  def false_text
    I18n.t('sheet.no_text')
  end
end
