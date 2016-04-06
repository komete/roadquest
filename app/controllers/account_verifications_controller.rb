class AccountVerificationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.is_verified? && user.authenticated?(:verified, params[:id])
      user.is_now_verified
      AccountMailer.send_notification(user).deliver_now
      flash[:success] = "Compte activé avec succés!"
      redirect_to root_path
    else
      flash[:danger] = "Activation du compte invalide !"
      redirect_to root_path
    end
  end
end
