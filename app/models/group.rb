class Group < ApplicationRecord
  has_many :members, dependent: :destroy

  validates :name, presence: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }, presence: true
end
