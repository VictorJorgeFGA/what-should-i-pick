namespace :op_gg_api do
  task fetch_statistics: :environment do
    Statistic.positions.each_key do |position|
      response = HTTParty.get("https://op.gg/api/v1.0/internal/bypass/statistics/global/champions/ranked?period=month&tier=all&position=#{position}")['data']
      response.each do |stats|
        champion = Champion.find_by(key: stats['champion_id'])
        next unless champion

        champion.statistics.create(
          {
            tier: 'all',
            position:,
            win_rate: stats['win'].to_f / stats['play'],
            pick_rate: stats['pick_rate'],
            period: 'month',
            region: 'global'
          }
        )
      end
    end
  end
end
