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
end
