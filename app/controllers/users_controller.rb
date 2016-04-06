class UsersController < ApplicationController
  all_application_helpers

  before_action :logged_admin, only: [:gestion, :activation]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    if params[:ref_entreprise][:ref_entreprise] &&  params[:ref_entreprise][:ref_entreprise] != ''
      @user = Entrepreneur.create(:nom => params[:user][:nom], :prenom => params[:user][:prenom], :email => params[:user][:email],
                               :poste => params[:user][:poste], :telephone => params[:user][:telephone], :codeEmploye => params[:user][:codeEmploye],
                               :username => params[:user][:username], :password => params[:user][:password],
                               :password_confirmation => params[:user][:password_confirmation], :ref_entreprise => params[:ref_entreprise][:ref_entreprise])

      @user.send_verification_email
      flash[:info] = "Un email a été envoyé aux administrateurs pour la validation de votre compte."
      redirect_to root_path
    else
      @user = User.new(user_params)
      if @user.save
        @user.send_verification_email
        flash[:info] = "Un email a été envoyé aux administrateurs pour la validation de votre compte."
        redirect_to root_path
      else
        render 'new'
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Utilisateur mis à jours"
      if @user.administrateur?
        redirect_to dashboard_path
      else
        redirect_to root_path
      end
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.is_now_desactivated
    flash[:info] = "Utilisateur désactivé"
    redirect_to users_gestion_path
  end

  def gestion
    @users = User.all
  end

  def activation
    @user = User.find(params[:id])
    @user.is_now_verified
    AccountMailer.send_notification(@user).deliver_now
    redirect_to users_gestion_path
  end

  :private

  def correct_user
    user = current_user
    unless user.id == params[:id] || user.administrateur
      flash[:danger] = "Vous n'avez pas l'authorisation d'effectuer cette action !"
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:nom, :prenom, :email, :poste, :telephone, :codeEmploye, :username, :password, :password_confirmation)
  end
end
