module Api
  class PaymentsController < ApplicationController
    def index
      group = Group.find(params[:group_id])
      render json: group.payments
    end

    def create
      group  = Group.find(params[:group_id])
      member = group.members.find_by(id: payment_params[:member_id])
      if member.nil?
        render json: { errors: [ "メンバーはこのグループに属していません" ] }, status: :unprocessable_entity
        return
      end
      payment = member.build_payment(amount: payment_params[:amount])
      if payment.save
        render json: payment, status: :created
      else
        render json: { errors: payment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def payment_params
      params.require(:payment).permit(:member_id, :amount)
    end
  end
end
