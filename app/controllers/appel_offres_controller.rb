class AppelOffresController < ApplicationController
  all_application_helpers

  before_action :logged_user, only: [:new, :create, :edit, :update, :to_assign]

  def index
    @appels = AppelOffre.all
  end

  def show
    @appel = AppelOffre.find(params[:id])
  end

  def new
    @appel = AppelOffre.new
  end

  def create

  end

  def edit
    @appel = AppelOffre.find(params[:id])
  end

  def update

  end

  def to_assign

  end

  :private

  def appel_params
    params.require(:appel_offre).permit(:nom, :prenom, :email, :poste, :telephone, :codeEmploye, :username, :password, :password_confirmation)
  end

end
