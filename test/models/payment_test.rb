require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  setup do
    @group  = Group.create!(name: "テストグループ", total_amount: 10000)
    @member = Member.create!(name: "田中", group: @group)
  end

  test "メンバーと金額があれば保存できる" do
    payment = Payment.new(member: @member, amount: 3000)
    assert payment.valid?
  end

  test "金額が0でも保存できる" do
    payment = Payment.new(member: @member, amount: 0)
    assert payment.valid?
  end

  test "金額を指定しなければ0になる" do
    payment = Payment.new(member: @member)
    assert_equal 0, payment.amount
  end

  test "金額が負の数なら保存できない" do
    payment = Payment.new(member: @member, amount: -1)
    assert_not payment.valid?
  end

  test "メンバーがなければ保存できない" do
    payment = Payment.new(amount: 3000)
    assert_not payment.valid?
  end

  test "同じメンバーで2つ目の支払いは作れない" do
    Payment.create!(member: @member, amount: 3000)
    payment = Payment.new(member: @member, amount: 5000)
    assert_not payment.valid?
  end

  test "別グループのメンバーでは保存できない" do
    other_group  = Group.create!(name: "別グループ", total_amount: 0)
    other_member = Member.create!(name: "山田", group: other_group)
    payment = Payment.new(group: @group, member: other_member, amount: 3000)
    assert_not payment.valid?
  end
end
