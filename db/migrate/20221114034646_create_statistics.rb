class CreateStatistics < ActiveRecord::Migration[7.0]
  def change
    create_table :statistics do |t|
      t.integer :tier
      t.integer :position
      t.float :win_rate
      t.float :pick_rate
      t.float :performance
      t.integer :period
      t.integer :region
      t.references :champion, null: false, foreign_key: true

      t.timestamps
    end

    add_index :statistics, [:tier, :position, :region, :period, :champion_id], name: 'statistics_uniqueness_constraint_index', unique: true
  end
end
