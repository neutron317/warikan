# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# グループ
ryoko  = Group.find_or_create_by!(name: "旅行").tap { |g| g.update!(total_amount: 50000) }
nomikai = Group.find_or_create_by!(name: "飲み会").tap { |g| g.update!(total_amount: 15000) }
bbq    = Group.find_or_create_by!(name: "BBQ").tap { |g| g.update!(total_amount: 8000) }
Group.find_or_create_by!(name: "ランチ")
Group.find_or_create_by!(name: "カラオケ")

# メンバー
Member.find_or_create_by!(name: "田中", group: ryoko)
Member.find_or_create_by!(name: "鈴木", group: ryoko)
Member.find_or_create_by!(name: "佐藤", group: ryoko)

Member.find_or_create_by!(name: "山田", group: nomikai)
Member.find_or_create_by!(name: "伊藤", group: nomikai)

Member.find_or_create_by!(name: "渡辺", group: bbq)
Member.find_or_create_by!(name: "中村", group: bbq)
Member.find_or_create_by!(name: "小林", group: bbq)
Member.find_or_create_by!(name: "加藤", group: bbq)
