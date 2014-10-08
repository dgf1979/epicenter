class VerificationsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @verification = Verification.new
  end

  def update
    @verification = Verification.new(params[:verification].merge(bank_account: current_user.bank_account))
    if @verification.confirm
      flash[:notice] = "Your bank account has been confirmed."
      redirect_to new_upfront_payment_path
    else
      render :edit
    end
  end
end
