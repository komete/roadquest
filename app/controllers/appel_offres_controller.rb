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
    @appel = AppelOffre.new(appel_params)
  end

  def edit
    @appel = AppelOffre.find(params[:id])
  end

  def update
    @appel.update_attributes(appel_params)
  end

  def to_assign

  end

  :private

  def appel_params
    params.require(:appel_offre).permit(:budget, :periode, :description, :document_annexe)
  end

end
