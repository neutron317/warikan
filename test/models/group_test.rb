require "test_helper"

class GroupTest < ActiveSupport::TestCase
  test "名前があれば保存できる" do
    group = Group.new(name: "テスト旅行")
    assert group.valid?
  end

  test "名前が空なら保存できない" do
    group = Group.new(name: "")
    assert_not group.valid?
  end

  test "合計金額が0以上なら保存できる" do
    group = Group.new(name: "テスト旅行", total_amount: 0)
    assert group.valid?
  end

  test "合計金額が正の数なら保存できる" do
    group = Group.new(name: "テスト旅行", total_amount: 30000)
    assert group.valid?
  end

  test "合計金額を指定しなければ0になる" do
    group = Group.new(name: "テスト旅行")
    assert_equal 0, group.total_amount
  end

  test "合計金額が負の数なら保存できない" do
    group = Group.new(name: "テスト旅行", total_amount: -1)
    assert_not group.valid?
  end

  test "全員が均等に払えば精算なし" do
    group  = Group.create!(name: "旅行", total_amount: 3000)
    m1     = Member.create!(name: "田中", group: group)
    m2     = Member.create!(name: "鈴木", group: group)
    m3     = Member.create!(name: "佐藤", group: group)
    Payment.create!(member: m1, amount: 1000)
    Payment.create!(member: m2, amount: 1000)
    Payment.create!(member: m3, amount: 1000)
    assert_equal [], group.settlements
  end

  test "払いすぎ・払い不足があれば精算リストを返す" do
    group  = Group.create!(name: "旅行", total_amount: 3000)
    tanaka = Member.create!(name: "田中", group: group)
    suzuki = Member.create!(name: "鈴木", group: group)
    sato   = Member.create!(name: "佐藤", group: group)
    Payment.create!(member: tanaka, amount: 3000)
    Payment.create!(member: suzuki, amount: 0)
    Payment.create!(member: sato,   amount: 0)
    result = group.settlements
    assert_equal 2, result.length
    assert result.all? { |s| s[:to] == tanaka }
    # 3000 ÷ 3 = ちょうど1000円（端数なし）
    assert result.all? { |s| s[:amount] == 1000 }
  end

  test "total_amountが0なら精算なし" do
    group = Group.create!(name: "旅行", total_amount: 0)
    Member.create!(name: "田中", group: group)
    assert_equal [], group.settlements
  end

  test "paymentが未登録のメンバーは払っていないとして計算する" do
    group  = Group.create!(name: "旅行", total_amount: 2000)
    tanaka = Member.create!(name: "田中", group: group)
    suzuki = Member.create!(name: "鈴木", group: group)
    Payment.create!(member: tanaka, amount: 2000)
    result = group.settlements
    assert_equal 1, result.length
    assert_equal suzuki, result[0][:from]
    assert_equal tanaka, result[0][:to]
    assert_equal 1000, result[0][:amount]
  end

  test "端数はcreditorが得をするよう切り上げで精算する" do
    group  = Group.create!(name: "旅行", total_amount: 10000)
    tanaka = Member.create!(name: "田中", group: group)
    suzuki = Member.create!(name: "鈴木", group: group)
    sato   = Member.create!(name: "佐藤", group: group)
    Payment.create!(member: tanaka, amount: 10000)
    Payment.create!(member: suzuki, amount: 0)
    Payment.create!(member: sato,   amount: 0)
    result = group.settlements
    total_received = result.sum { |s| s[:amount] }
    # 10000 ÷ 3 = 3333.33... → 切り上げによりcreditorは6667円以上受け取る
    assert total_received >= 6667
    assert result.all? { |s| s[:to] == tanaka }
  end

  test "concentrated_on指定時は端数がそのメンバーに集中する" do
    group  = Group.create!(name: "旅行", total_amount: 10000)
    tanaka = Member.create!(name: "田中", group: group)
    suzuki = Member.create!(name: "鈴木", group: group)
    sato   = Member.create!(name: "佐藤", group: group)
    Payment.create!(member: tanaka, amount: 10000)
    Payment.create!(member: suzuki, amount: 0)
    Payment.create!(member: sato,   amount: 0)
    result = group.settlements(concentrated_on: sato)
    suzuki_payment = result.find { |s| s[:from] == suzuki }
    sato_payment   = result.find { |s| s[:from] == sato }
    # 鈴木は切り捨て3333円、佐藤が残り3334円を負担
    assert_equal 3333, suzuki_payment[:amount].to_i
    assert_equal 3334, sato_payment[:amount].to_i
  end
end
