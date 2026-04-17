require "test_helper"

class MemberTest < ActiveSupport::TestCase
  setup do
    @group = Group.create!(name: "テストグループ")
  end

  test "名前とグループがあれば保存できる" do
    member = Member.new(name: "田中", group: @group)
    assert member.valid?
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

  test "weightが整数なら保存できる" do
    member = Member.new(name: "田中", group: @group, weight: 2)
    assert member.valid?
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
end
