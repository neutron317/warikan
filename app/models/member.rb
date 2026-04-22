class Member < ApplicationRecord
  belongs_to :group
  has_one :payment, dependent: :destroy

  validates :name, presence: true
  validates :weight, numericality: { greater_than: 0 }

  def amount_due
    (weight * group.total_amount / group.members.sum(:weight)).to_i
  end

  def as_json(options = {})
    super(options).merge("amount_due" => amount_due)
  end
end
