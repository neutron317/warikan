require "test_helper"

class Api::GroupsControllerTest < ActionDispatch::IntegrationTest
  test "グループ一覧を取得できる" do
    Group.create!(name: "旅行")
    get "/api/groups"
    assert_response :success
    json = JSON.parse(response.body)
    assert json.any? { |g| g["name"] == "旅行" }
  end

  test "グループを作成できる" do
    post "/api/groups",
      params: { group: { name: "飲み会" } },
      as: :json
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "飲み会", json["name"]
  end

  test "合計金額を指定してグループを作成できる" do
    post "/api/groups",
      params: { group: { name: "飲み会", total_amount: 10000 } },
      as: :json
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal 10000, json["total_amount"]
  end

  test "名前が空なら作成できない" do
    post "/api/groups",
      params: { group: { name: "" } },
      as: :json
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert json["errors"].present?
  end

  test "IDでグループを取得できる" do
    group = Group.create!(name: "登山")
    get "/api/groups/#{group.id}"
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "登山", json["name"]
  end
end
