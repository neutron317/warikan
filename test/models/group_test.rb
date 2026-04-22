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
    result = group.settlements
    assert_equal [], result[:settlements]
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
    assert_equal 2, result[:settlements].length
    assert result[:settlements].all? { |s| s[:to] == tanaka }
    assert result[:settlements].all? { |s| s[:amount] == 1000 }
  end

  test "paymentが未登録のメンバーは払っていないとして計算する" do
    group  = Group.create!(name: "旅行", total_amount: 2000)
    tanaka = Member.create!(name: "田中", group: group)
    suzuki = Member.create!(name: "鈴木", group: group)
    Payment.create!(member: tanaka, amount: 2000)
    result = group.settlements
    assert_equal 1, result[:settlements].length
    assert_equal suzuki, result[:settlements][0][:from]
    assert_equal tanaka, result[:settlements][0][:to]
    assert_equal 1000,   result[:settlements][0][:amount]
  end

  test "割り切れない場合はremainderとlosersとして返す" do
    group  = Group.create!(name: "旅行", total_amount: 10000)
    tanaka = Member.create!(name: "田中", group: group)
    suzuki = Member.create!(name: "鈴木", group: group)
    sato   = Member.create!(name: "佐藤", group: group)
    Payment.create!(member: tanaka, amount: 10000)
    Payment.create!(member: suzuki, amount: 0)
    Payment.create!(member: sato,   amount: 0)
    result = group.settlements
    # 10000 ÷ 3 = 3333（切り捨て）× 3 = 9999 → remainder = 1
    assert_equal 1, result[:remainder]
    assert_equal tanaka, result[:losers][0][:member]
    assert_equal 1, result[:losers][0][:amount]
    assert result[:settlements].all? { |s| s[:to] == tanaka }
  end
end
