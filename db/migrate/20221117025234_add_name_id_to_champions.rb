class AddNameIdToChampions < ActiveRecord::Migration[7.0]
  def change
    add_column :champions, :name_id, :string
  end
end
