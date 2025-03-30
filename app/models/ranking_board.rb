class RankingBoard < ApplicationRecord
  MAX_LIST_COUNT = 100

  belongs_to :project

  before_create do
    # 並行処理しない前提でランキングボード番号を生成
    self.num = project.ranking_boards.count + 1
  end
end
