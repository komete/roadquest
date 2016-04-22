class PagesController < ApplicationController
  all_application_helpers

  before_action :logged_user, only: [:cartes, :offres, :dashboard]
  before_action :logged_admin, only: [:dashboard]

  def acceuil

  end

  def cartes
    @num_route = TronconRoute.select(:num_route).distinct
    @vocation = TronconRoute.select(:vocation).distinct
    @nb_chausse = TronconRoute.select(:nb_chausse).distinct
    @nb_voies = TronconRoute.select(:nb_voies).distinct
    @etat = TronconRoute.select(:etat).distinct
    @acces = TronconRoute.select(:acces).distinct
    @sens = TronconRoute.select(:sens).distinct
    @class_adm = TronconRoute.select(:class_adm).distinct
  end

  def offres

  end

  def recherches

  end

  def dashboard

  end
end
