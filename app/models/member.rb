class Member < ApplicationRecord
  belongs_to :group
  has_one :payment, dependent: :destroy

  validates :name, presence: true
  validates :weight, numericality: { greater_than: 0 }

  def amount_due
    return 0 if group.total_amount.zero?
    total_weight = group.members.sum(:weight)
    (weight / total_weight) * group.total_amount
  end

  def as_json(options = {})
    super(options).merge("amount_due" => amount_due)
  end
end
