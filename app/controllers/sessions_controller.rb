class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      if user.verified
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        if user.is_admin?
          redirect_to users_gestion_path
        else
          redirect_to root_path
        end
      else
        flash[:danger] = "Désolé votre compte n'a pas été encore activé"
        redirect_to root_path
      end
    else
      flash.now[:danger] = 'Combinaison invalide nom d\'utilisateur et/ou mot de passe'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = "Vous avez été déconnecté avec succès"
    redirect_to root_path
  end
end
