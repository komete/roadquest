class PagesController < ApplicationController
  all_application_helpers

  before_action :logged_user, only: [:cartes, :offres, :dashboard]
  before_action :logged_admin, only: [:dashboard]

  def acceuil

  end

  def cartes

  end
  def offres

  end
  def recherches

  end

  def dashboard

  end
end
