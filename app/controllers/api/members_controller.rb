module Api
  class MembersController < ApplicationController
    def index
      group = Group.find(params[:group_id])
      render json: group.members
    end

    def create
      group = Group.find(params[:group_id])
      member = group.members.new(member_params)
      if member.save
        render json: member, status: :created
      else
        render json: { errors: member.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def member_params
      params.require(:member).permit(:name)
    end
  end
end
