module Api
  class SettlementsController < ApplicationController
    def index
      group  = Group.find(params[:group_id])
      result = group.settlements
      render json: {
        settlements: result[:settlements].map { |s|
          { from: s[:from].name, to: s[:to].name, amount: s[:amount] }
        },
        remainder: result[:remainder],
        losers: result[:losers].map { |l| { name: l[:member].name, amount: l[:amount] } }
      }
    end
  end
end
