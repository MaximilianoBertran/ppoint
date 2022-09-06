class PurchasesController < ApplicationController
  before_action :authorized

  def index
    render json: Purchase.purchases_filter(params)
  end

  def top_sell
    render json: Purchase.top('units')
  end

  def top_amount
    render json: Purchase.top('amount')
  end

  def graphic
    render json: Purchase.graphic(params[:granularity])
  end
end
