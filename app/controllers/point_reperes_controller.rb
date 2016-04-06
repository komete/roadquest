class PointReperesController < ApplicationController

  all_application_helpers

  before_action :logged_user, only: [:edit, :update, :show]
  before_action :logged_admin, only: [:new, :create, :destroy]
  before_action :set_point_repere, only: [:show, :edit, :update, :destroy]


  def index
    @point_reperes = PointRepere.all
  end


  def show
  end


  def new
    @point_repere = PointRepere.new
  end


  def edit
  end

  def create
    @point_repere = PointRepere.new(point_repere_params)
    @point_repere.save
  end


  def update
    @point_repere.update(point_repere_params)
  end

  def destroy
    @point_repere.destroy
  end

  :private

    def set_point_repere
      @point_repere = PointRepere.find(params[:id])
    end

    def point_repere_params
      params.require(:point_repere).permit(:latitude, :longitude, :projection)
    end
end
