class CreateChampions < ActiveRecord::Migration[7.0]
  def change
    create_table :champions do |t|
      t.string :name
      t.integer :key
      t.string :title
      t.string :image_full
      t.string :image_sprite
      t.text :lore
      t.text :blurb
      t.integer :hp
      t.integer :move_speed
      t.integer :armor
      t.integer :attack_range
      t.integer :attack_damage
      t.float :crit
      t.integer :attack
      t.integer :defense
      t.integer :magic
      t.integer :difficulty
      t.string :primary_role
      t.string :secondary_role
      t.text :enemy_tips
      t.text :ally_tips

      t.timestamps
    end

    add_index :champions, :key, unique: true
  end
end
