module Api
  class GroupsController < ApplicationController
    def index
      groups = Group.all
      render json: groups
    end

    def show
      group = Group.find(params[:id])
      render json: group
    end

    def create
      group = Group.new(group_params)
      if group.save
        render json: group, status: :created
      else
        render json: { errors: group.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def group_params
      params.require(:group).permit(:name, :total_amount)
    end
  end
end
