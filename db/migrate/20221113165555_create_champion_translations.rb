class CreateChampionTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :champion_translations do |t|
      t.string :locale, null: false
      t.string :title
      t.text :lore
      t.text :blurb
      t.text :enemy_tips
      t.text :ally_tips
      t.references :champion, null: false, foreign_key: true

      t.timestamps
    end

    add_index :champion_translations, :locale, unique: true
  end
end
