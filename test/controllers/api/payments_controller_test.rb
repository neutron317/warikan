require "test_helper"

class Api::PaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group  = Group.create!(name: "旅行", total_amount: 50000)
    @member = Member.create!(name: "田中", group: @group)
  end

  test "支払い一覧を取得できる" do
    Payment.create!(member: @member, amount: 20000)
    get "/api/groups/#{@group.id}/payments"
    assert_response :success
    json = JSON.parse(response.body)
    assert json.any? { |p| p["amount"] == 20000 }
  end

  test "支払いを作成できる" do
    post "/api/groups/#{@group.id}/payments",
      params: { payment: { member_id: @member.id, amount: 5000 } },
      as: :json
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal 5000, json["amount"]
  end

  test "金額が負の数なら作成できない" do
    post "/api/groups/#{@group.id}/payments",
      params: { payment: { member_id: @member.id, amount: -1 } },
      as: :json
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert json["errors"].present?
  end

  test "別グループのメンバーIDでは作成できない" do
    other_group  = Group.create!(name: "飲み会", total_amount: 15000)
    other_member = Member.create!(name: "山田", group: other_group)
    post "/api/groups/#{@group.id}/payments",
      params: { payment: { member_id: other_member.id, amount: 5000 } },
      as: :json
    assert_response :not_found
  end
end
