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

    result = build_settlements(creditors, debtors)

    losers = creditors.select { |c| c[:balance] > 0 }
                      .map { |c| { member: c[:member], amount: c[:balance] } }

    { settlements: result, remainder: remainder, losers: losers }
  end

  private

  def build_settlements(creditors, debtors, result = [])
    return result if creditors.empty? || debtors.empty?

    amount = [ creditors.first[:balance], -debtors.first[:balance] ].min
    result << { from: debtors.first[:member], to: creditors.first[:member], amount: amount }
    creditors.first[:balance] -= amount
    debtors.first[:balance]   += amount

    creditors.shift if creditors.first[:balance] <= 0
    debtors.shift   if debtors.first[:balance] >= 0

    build_settlements(creditors, debtors, result)
  end
end
