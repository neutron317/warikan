module Api
  class SettlementsController < ApplicationController
    def index
      group  = Group.find(params[:group_id])
      target = params[:concentrated_on] ? group.members.find_by(id: params[:concentrated_on]) : nil
      render json: group.settlements(concentrated_on: target).map { |s|
        { from: s[:from].name, to: s[:to].name, amount: s[:amount] }
      }
    end
  end
end
