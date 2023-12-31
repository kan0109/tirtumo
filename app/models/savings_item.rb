class SavingsItem < ApplicationRecord
  belongs_to :user
  has_one :record

  validates :name, presence: true, length: { maximum: 100 }
  validates :amount, presence: true, numericality: { less_than: 1000 }
end
