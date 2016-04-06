class ProduitsController < ApplicationController
  all_application_helpers

  before_action :logged_user, only: [:show]
  before_action :logged_admin, only: [:show]
  before_action :set_produit, only: [:show,]

  def show

  end

  def new
    @id = params[:id]
    @produit = Produit.new
  end

  def create
    @produit = Produit.create(:nom => params[:produit][:nom], :type_produit => params[:produit][:type_produit],
                           :expiration => params[:produit][:expiration], :reference => params[:produit][:reference], :marquage_id => params[:marquage_id])
    redirect_to controller: "produits", action: "show", id: @produit.id
  end

  :private

  def set_produit
    @produit = Produit.find(params[:id])
    id = Produit.find(params[:id]).marquage_id
    @m = Marquage.find(id)
    if @m.type_marquage=="lineaires"
      @marquage = MarquageLineaire.find(id)
    else
      @marquage = MarquageSpecialise.find(id)
    end
  end

  def produits_params
    params.require(:produit).permit(:nom, :type_produit, :expiration, :reference)
  end
end
