class Customer::FindOrInitializeFromSheetData
  include StatelessService

  CUSTOMER_ATTRIBUTES = {
    email: 0,
    fullname: 1
  }.freeze
  private_constant :CUSTOMER_ATTRIBUTES

  initialize_with :row

  def call
    customer_by_email || initialize_customer
  end

  private

  def initialize_customer
    Customer.new(customer_attributes)
  end

  def customer_by_email
    Customer.find_by(email: customer_attributes[:email])
  end

  def customer_attributes
    @customer_attributes ||= CUSTOMER_ATTRIBUTES.map do |attribute, index|
      [attribute, row[index]]
    end.to_h
  end
end
