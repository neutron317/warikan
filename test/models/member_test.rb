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
end
