class Target < ApplicationRecord
  belongs_to :user

  validates :target, presence: true, length: { maximum: 100 }
end
