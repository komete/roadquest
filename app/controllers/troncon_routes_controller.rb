require 'georuby'
require 'geo_ruby/shp'
require 'geo_ruby/shp4r/shp'

include GeoRuby::Shp4r
include GeoRuby::SimpleFeatures

class TronconRoutesController < ApplicationController
  all_application_helpers

  before_action :logged_user, only: [:show]
  before_action :set_troncon_route, only: [:show, :show_travaux]

  def select

  end

  def import
    params_import = Hash.new
    @shpfile = "/home/remi/shapes/" + params[:file]
    #@shpfile = "/Users/remiguillaume/Downloads/" + params[:file]

    ShpFile.open(@shpfile) do |shp|
      shp.each do |shape|
        shp.fields.each do |field|
          donnees = shape.data[field.name]
          if donnees.is_a? String
            params_import[field.name.downcase] = Iconv.conv('UTF-8', 'iso8859-1', donnees)
          else
            params_import[field.name.downcase] = donnees unless field.name.downcase=='id_rte500'
          end
        end
t
        num = params_import["num_route"]

        if Route.exists?(num_route: num)
          @route = Route.find_by_num_route(num)
        else
          @route = Route.new(:num_route => num)
          @route.save

        end

        @troncon_route = TronconRoute.new(:vocation=>params_import["vocation"],:nb_chausse=>params_import["nb_chausse"],
        :nb_voies=>params_import["nb_voies"],:etat=>params_import["etat"],:acces=>params_import["acces"],:res_vert=>params_import["res_vert"],
        :sens=>params_import["sens"],:res_europe=>params_import["res_europe"],:num_route=>params_import["num_route"],
        :class_adm=>params_import["class_adm"],:longueur=>params_import["longueur"],:route_id=>@route.id)
        @troncon_route.save
      end
    end
    flash[:success] = "Données importées avec succès"
    redirect_to troncon_routes_path
  end

  def index
    @troncon_routes = TronconRoute.all
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "troncon_route_" + @troncon_route.id.to_s, encoding: "UTF-8"
      end
    end
  end

  def show_travaux

  end

  :private

  def set_troncon_route
    @troncon_route = TronconRoute.find(params[:id])
  end
end
