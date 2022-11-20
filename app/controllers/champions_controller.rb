class ChampionsController < ApplicationController
  # helper Statistic::available_positions # TODO

  def index
    field = params[:sort]&.split('-')&.first || 'name_id'
    sort_type = params[:sort]&.split('-')&.second || 'asc'
    @sort = { field => sort_type }

    br_msg = "Invalid sort #{field}: #{sort_type}"
    raise ActionController::BadRequest.new, br_msg unless field.in?(['name_id', 'performance', 'win_rate', 'pick_rate']) && sort_type.in?(['asc', 'desc'])

    @tier = params[:tier] || 'all'
    raise ActionController::BadRequest.new, "Invalid tier #{@tier}" unless Statistic.a_valid_tier? @tier

    @region = params[:region] || 'global'
    raise ActionController::BadRequest.new, "Invalid region #{@region}" unless Statistic.a_valid_region? @region

    @position = params[:position] || 'all'
    raise ActionController::BadRequest.new, "Invalid position #{@position}" unless Statistic.a_valid_position? @position

    all_champions = Champion.all_champions_filtered_by(tier: @tier, region: @region, position: @position)
    @champions = Champion.sort_champions_array_by(all_champions, field:, sort_type:)
  end

  def show
    @champion = Champion.find(params[:id])
  end
end
