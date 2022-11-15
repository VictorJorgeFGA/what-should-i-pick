namespace :op_gg_api do
  task fetch_statistics: :environment do
    Statistic.positions.each_key do |position|
      Statistic.tiers.each_key do |tier|
        puts "### Getting response from OP GG for position #{position}, tier #{tier}..."
        response = HTTParty.get("https://op.gg/api/v1.0/internal/bypass/statistics/global/champions/ranked?period=month&tier=#{tier}&position=#{position}")['data']
        response.each do |stats|
          champion = Champion.find_by(key: stats['champion_id'])
          next unless champion

          puts "Filling #{champion.name} with data..."

          statistic = champion.statistics.create(
            {
              tier:,
              position:,
              win_rate: stats['win'].to_f / stats['play'],
              pick_rate: stats['pick_rate'],
              period: 'month',
              region: 'global',
              kill: stats['kill'].to_i,
              death: stats['death'].to_i,
              assist: stats['assist'].to_i
            }
          )
          unless statistic.persisted?
            puts "Failed to fill #{champion.name} with data. Error: #{statistic.errors.full_messages.join('. ')}"
          end
        end
      end
    end
  end
end
