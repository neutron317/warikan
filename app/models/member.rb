class Member < ApplicationRecord
  belongs_to :group
  has_many :payments, dependent: :destroy

  validates :name, presence: true
end
