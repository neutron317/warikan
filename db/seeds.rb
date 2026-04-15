# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# グループ
ryoko   = Group.create!(name: "旅行")
nomikai = Group.create!(name: "飲み会")
bbq     = Group.create!(name: "BBQ")
Group.create!(name: "ランチ")
Group.create!(name: "カラオケ")

# メンバー
Member.create!(name: "田中", group: ryoko)
Member.create!(name: "鈴木", group: ryoko)
Member.create!(name: "佐藤", group: ryoko)

Member.create!(name: "山田", group: nomikai)
Member.create!(name: "伊藤", group: nomikai)

Member.create!(name: "渡辺", group: bbq)
Member.create!(name: "中村", group: bbq)
Member.create!(name: "小林", group: bbq)
Member.create!(name: "加藤", group: bbq)
