# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# 合計金額が設定済みのグループ
Group.find_or_create_by!(name: "旅行").update!(total_amount: 50000)
Group.find_or_create_by!(name: "飲み会").update!(total_amount: 15000)
Group.find_or_create_by!(name: "BBQ").update!(total_amount: 8000)

# 合計金額が未設定のグループ（後から設定する想定）
Group.find_or_create_by!(name: "ランチ")
Group.find_or_create_by!(name: "カラオケ")
