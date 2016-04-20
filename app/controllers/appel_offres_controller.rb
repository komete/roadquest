class AppelOffresController < ApplicationController
  all_application_helpers

  before_action :logged_user, only: [:new, :create, :edit, :update]

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

  :private


end
