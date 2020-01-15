class Notification < ApplicationRecord
  has_paper_trail

  validates :tax_amount, :customer, :sheet, :period, :payment_deadline_on, presence: true
  validates :customer, uniqueness: { scope: :sheet }

  belongs_to :customer
  belongs_to :sheet

  scope :past, -> { where('send_at <= :date', date: Date.today.end_of_day) }
  scope :not_delivered, -> { where(delivered_at: nil) }
end
