class CreateRecentRankItems < ActiveRecord::Migration[8.0]
  def change
    create_table :recent_rank_items do |t|
      t.references :ranking_board, null: false, foreign_key: true
      t.float :score, null: false, index: true, comment: "最新の記録"
      t.string :uid, null: false
      t.boolean :new_record_score, null: false, default: false, comment: "新記録かどうか"

      t.timestamps
    end
    add_index :recent_rank_items, :uid, unique: true
  end
end
