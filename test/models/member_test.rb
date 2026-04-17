require "test_helper"

class MemberTest < ActiveSupport::TestCase
  setup do
    @group = Group.create!(name: "テストグループ")
  end

  test "名前が空なら保存できない" do
    member = Member.new(name: "", group: @group)
    assert_not member.valid?
  end

  test "グループがなければ保存できない" do
    member = Member.new(name: "田中")
    assert_not member.valid?
  end

  test "weightのデフォルト値は1" do
    member = Member.create!(name: "田中", group: @group)
    assert_equal 1, member.weight
  end

  test "weightが小数なら保存できる" do
    member = Member.new(name: "田中", group: @group, weight: 1.5)
    assert member.valid?
  end

  test "weightが0なら保存できない" do
    member = Member.new(name: "田中", group: @group, weight: 0)
    assert_not member.valid?
  end

  test "weightが負の数なら保存できない" do
    member = Member.new(name: "田中", group: @group, weight: -1)
    assert_not member.valid?
  end

  test "weightがnilなら保存できない" do
    member = Member.new(name: "田中", group: @group, weight: nil)
    assert_not member.valid?
  end

  test "均等割りで正しく計算される" do
    group = Group.create!(name: "均等グループ", total_amount: 3000)
    m1 = Member.create!(name: "田中", group: group)
    m2 = Member.create!(name: "鈴木", group: group)
    m3 = Member.create!(name: "佐藤", group: group)
    assert_in_delta 1000, m1.amount_due, 0.01
    assert_in_delta 1000, m2.amount_due, 0.01
    assert_in_delta 1000, m3.amount_due, 0.01
  end

  test "傾斜ありで正しく計算される" do
    group = Group.create!(name: "傾斜グループ", total_amount: 15000)
    tanaka = Member.create!(name: "田中", group: group, weight: 2)
    suzuki = Member.create!(name: "鈴木", group: group, weight: 1)
    sato   = Member.create!(name: "佐藤", group: group, weight: 1)
    assert_in_delta 7500, tanaka.amount_due, 0.01
    assert_in_delta 3750, suzuki.amount_due, 0.01
    assert_in_delta 3750, sato.amount_due, 0.01
  end

  test "total_amountが0なら0を返す" do
    group  = Group.create!(name: "ゼログループ", total_amount: 0)
    member = Member.create!(name: "田中", group: group)
    assert_equal 0, member.amount_due
  end
end
