class Customer < ApplicationRecord
  has_paper_trail

  validates :fullname, presence: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates_uniqueness_of :email

  has_many :notifications
end
