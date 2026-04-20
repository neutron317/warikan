module Api
  class PaymentsController < ApplicationController
    def index
      group = Group.find(params[:group_id])
      render json: group.payments
    end

    def create
      group   = Group.find(params[:group_id])
      member  = group.members.find(payment_params[:member_id])
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
