class Member < ApplicationRecord
  belongs_to :group
  has_one :payment, dependent: :destroy

  validates :name, presence: true
end
