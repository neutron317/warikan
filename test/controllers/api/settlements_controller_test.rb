require "test_helper"

class Api::SettlementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group  = Group.create!(name: "旅行", total_amount: 3000)
    @tanaka = Member.create!(name: "田中", group: @group)
    @suzuki = Member.create!(name: "鈴木", group: @group)
    @sato   = Member.create!(name: "佐藤", group: @group)
    Payment.create!(member: @tanaka, amount: 3000)
    Payment.create!(member: @suzuki, amount: 0)
    Payment.create!(member: @sato,   amount: 0)
  end

  test "精算リストを取得できる" do
    get "/api/groups/#{@group.id}/settlements"
    assert_response :success
    json = JSON.parse(response.body)
    assert json.key?("settlements")
    assert json.key?("remainder")
    assert json.key?("losers")
    assert json["settlements"].all? { |s| s.key?("from_id") && s.key?("to_id") && s.key?("amount") }
    assert json["settlements"].any? { |s| s["to_id"] == @tanaka.id }
  end
end
