class CreateRankItems < ActiveRecord::Migration[8.0]
  def change
    create_table :rank_items do |t|
      t.string :type
      t.references :ranking_board, null: false, foreign_key: true
      t.float :score, null: false, index: true
      t.string :name
      t.string :uid, null: false

      t.timestamps
    end
    add_index :rank_items, :uid, unique: true
    add_index :rank_items, :updated_at
  end
end
