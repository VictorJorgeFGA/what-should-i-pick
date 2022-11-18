class ChampionsController < ApplicationController
  def index
    @tier = params[:tier] || 'all'
    unless Statistic.is_a_valid_tier?(@tier)
      raise ActionController::BadRequest.new(), "Invalid tier #{@tier}"
    end
    @champions = Champion.includes(:statistics).all
  end

  def show
    @champion = Champion.find(params[:id])
  end
end
