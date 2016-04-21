class AppelOffresController < ApplicationController
  all_application_helpers

  before_action :logged_user, only: [:new, :create, :edit, :update, :to_assign, :assign]

  def index
    @appels = AppelOffre.all
  end

  def show
    @appel = AppelOffre.find(params[:id])
    if @appel.entrepreneur_id
      @entrepreneur = Entrepreneur.find(@appel.entrepreneur_id)
    end
  end

  def new
    @appel = AppelOffre.new
  end

  def create
    @appel = AppelOffre.new(appel_params)
    if @appel.save
      flash[:success] = "Vôtre appel d'offre à été créé"
      redirect_to appel_offres_path
    else
      render 'new'
    end
  end

  def edit
    @appel = AppelOffre.find(params[:id])
  end

  def update
    @appel = AppelOffre.find(params[:id])
    @appel.update_attributes(appel_params)
    flash[:success] = "L'offre a été éditée avec succès"
    redirect_to appel_offre_path
  end

  def assign
    @appel = AppelOffre.find(params[:id])
    @entrepreneurs = Entrepreneur.all
  end

  def to_assign
    @appel = AppelOffre.find(params[:id])
    @appel.is_now_assigned params[:entrepreneur_id]
    flash[:success] = "Appel d\'offre attribué'"
    redirect_to appel_offre_path
  end

  :private

  def appel_params
    params.require(:appel_offre).permit(:budget, :periode, :description, :document_annexe)
  end

end
