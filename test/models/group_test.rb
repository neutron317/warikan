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
end
