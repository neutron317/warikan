module Api
  class SettlementsController < ApplicationController
    def index
      group  = Group.find(params[:group_id])
      result = group.settlements
      render json: {
        settlements: result[:settlements].map { |s|
          { from_id: s[:from].id, to_id: s[:to].id, amount: s[:amount] }
        },
        remainder: result[:remainder],
        losers: result[:losers].map { |l| { member_id: l[:member].id, amount: l[:amount] } }
      }
    end
  end
end
