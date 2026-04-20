class Payment < ApplicationRecord
  belongs_to :member

  validates :amount, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :member, uniqueness: true
end
