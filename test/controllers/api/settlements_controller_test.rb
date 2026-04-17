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
    assert json.all? { |s| s.key?("from") && s.key?("to") && s.key?("amount") }
    assert json.any? { |s| s["to"] == "田中" }
  end

  test "concentrated_onを指定すると端数がそのメンバーに集中する" do
    get "/api/groups/#{@group.id}/settlements?concentrated_on=#{@sato.id}"
    assert_response :success
    json = JSON.parse(response.body)
    sato_payment = json.find { |s| s["from"] == "佐藤" }
    assert_not_nil sato_payment
  end
end
