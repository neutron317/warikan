class Member < ApplicationRecord
  belongs_to :group
  has_one :payment, dependent: :destroy

  validates :name, presence: true
  validates :weight, numericality: { greater_than: 0 }
end
