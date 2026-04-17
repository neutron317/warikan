class Group < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :payments, through: :members

  validates :name, presence: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }, presence: true

  def settlements(concentrated_on: nil)
    return [] if total_amount.zero?

    total_weight = members.sum(:weight)

    # 各メンバーの負担額を算出
    # concentrated_on あり: 指定メンバー以外は切り捨て、指定メンバーが残りを全部負担
    # concentrated_on なし: 小数のまま保持（精算額を切り上げる際に使う）
    dues = {}
    if concentrated_on
      floored_sum = 0
      members.each do |member|
        next if member == concentrated_on
        due = ((member.weight / total_weight) * total_amount).floor
        dues[member] = due
        floored_sum += due
      end
      dues[concentrated_on] = total_amount - floored_sum
    else
      members.each do |member|
        dues[member] = ((member.weight / total_weight) * total_amount).round(2)
      end
    end

    balances = members.map do |member|
      paid = member.payment&.amount || 0
      { member: member, balance: (paid - dues[member]).round(2) }
    end

    creditors = balances.select { |b| b[:balance] > 0 }.map(&:dup)
    debtors   = balances.select { |b| b[:balance] < 0 }.map(&:dup)

    result = []
    i = j = 0
    while i < creditors.length && j < debtors.length
      raw = [ creditors[i][:balance], -debtors[j][:balance] ].min
      # concentrated_on なし: 切り上げて払いすぎた人（creditor）が得をする
      # concentrated_on あり: 端数は指定メンバーに集中済みなので切り上げ不要
      amount = concentrated_on ? raw : raw.ceil(0)
      result << { from: debtors[j][:member], to: creditors[i][:member], amount: amount }
      creditors[i][:balance] -= amount
      debtors[j][:balance]   += amount
      i += 1 if creditors[i][:balance] <= 0
      j += 1 if debtors[j][:balance] >= 0
    end

    result
  end
end
