class Group < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :payments, through: :members

  validates :name, presence: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }, presence: true

  def settlements
    dues = members.each_with_object({}) { |m, h| h[m] = m.amount_due }
    remainder = total_amount - dues.values.sum

    balances = members.map do |member|
      paid = member.payment&.amount || 0
      { member: , balance: paid - dues[member] }
    end

    creditors = balances.select { |b| b[:balance] > 0 }.map(&:dup)
    debtors   = balances.select { |b| b[:balance] < 0 }.map(&:dup)

    result = []
    i = j = 0
    while i < creditors.length && j < debtors.length
      amount = [ creditors[i][:balance], -debtors[j][:balance] ].min
      result << { from: debtors[j][:member], to: creditors[i][:member], amount: amount }
      creditors[i][:balance] -= amount
      debtors[j][:balance]   += amount
      i += 1 if creditors[i][:balance] <= 0
      j += 1 if debtors[j][:balance] >= 0
    end

    losers = creditors.select { |c| c[:balance] > 0 }
                      .map { |c| { member: c[:member], amount: c[:balance] } }

    { settlements: result, remainder: remainder, losers: losers }
  end
end
