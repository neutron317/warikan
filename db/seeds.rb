# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Group.create!(name: "旅行", total_amount: 50000)
Group.create!(name: "飲み会", total_amount: 15000)
Group.create!(name: "BBQ", total_amount: 8000)
Group.create!(name: "ランチ", total_amount: 0)
Group.create!(name: "カラオケ", total_amount: 0)
