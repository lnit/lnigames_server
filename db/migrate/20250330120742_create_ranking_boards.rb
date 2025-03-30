class CreateRankingBoards < ActiveRecord::Migration[8.0]
  def change
    create_table :ranking_boards do |t|
      t.string :type
      t.references :project, null: false, foreign_key: true
      t.integer :num, null: false

      t.timestamps
    end
    add_index :ranking_boards, :num, unique: true
  end
end
