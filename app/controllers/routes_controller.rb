class RoutesController < ApplicationController

  all_application_helpers

  before_action :logged_user, only: [:index, :show]
  before_action :set_route, only: [:show]

  def index
    @routes = Route.all
  end

  def show
  end


  :private

    def set_route
      @route = Route.find(params[:id])
    end

    def route_params
      params.require(:route).permit(:num_route)
    end
end
