class ChampionsController < ApplicationController
  def index
    @champions = Champion.all
  end

  def show
  end
end
