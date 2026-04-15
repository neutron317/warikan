require "test_helper"

class Api::MembersControllerTest < ActionDispatch::IntegrationTest
  test "メンバー一覧を取得できる" do
    group = Group.create!(name: "旅行", total_amount: 50000)
    Member.create!(name: "田中", group: group)
    get "/api/groups/#{group.id}/members"
    assert_response :success
    json = JSON.parse(response.body)
    assert json.any? { |m| m["name"] == "田中" }
  end

  test "メンバーを作成できる" do
    group = Group.create!(name: "旅行", total_amount: 50000)
    post "/api/groups/#{group.id}/members",
      params: { member: { name: "田中" } },
      as: :json
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "田中", json["name"]
  end

  test "名前が空なら作成できない" do
    group = Group.create!(name: "旅行", total_amount: 50000)
    post "/api/groups/#{group.id}/members",
      params: { member: { name: "" } },
      as: :json
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert json["errors"].present?
  end
end
