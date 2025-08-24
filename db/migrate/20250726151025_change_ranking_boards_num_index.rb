class ChangeRankingBoardsNumIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :ranking_boards, :num, unique: true
    add_index :ranking_boards, [:project_id, :num], unique: true
  end
end