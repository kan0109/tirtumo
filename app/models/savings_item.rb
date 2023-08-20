class SavingsItem < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :amount, presence: true
end
