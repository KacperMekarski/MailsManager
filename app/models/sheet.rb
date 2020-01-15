class Sheet < ApplicationRecord
  has_paper_trail

  validates_presence_of :title, :sheet_id

  has_many :notifications
end
