class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_encrypted_token
      @user.send_password_reset_email
      flash[:info] = "Un email vous a été envoyé avec les instructions"
      redirect_to root_path
    else
      flash.now[:danger] = "Adresse email invalide et/ou inconnue"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "Vous devez fournir un nouveau mot de passe")
      render 'edit'
    elsif @user.update_attributes(account_params)
      user = @user
      #login_in user
      flash[:success] = "Mot de passe réinitialisé avec succès"
      redirect_to root_path
    else
      render 'edit'
    end
  end

  :private

  def account_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless (@user && @user.is_verified? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_path
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash.now[:danger] = "Délai expiré ..."
      redirect_to password_resets_new_path
    end
  end
end
