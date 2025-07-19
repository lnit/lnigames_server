class PointRankingBoard < RankingBoard
  has_many :rank_items, class_name: 'PointRankItem', foreign_key: :ranking_board_id
  has_many :recent_items, class_name: 'RecentRankItem', foreign_key: :ranking_board_id

  def add_item!(params)
    item = rank_items.find_or_initialize_by(uid: params[:uid])

    # 新規レコード、または過去のスコアの方が低い場合にスコアを保存
    if item.new_record? || item.score <= params[:score].to_i
      new_record_score = true
      item.update!(params)
    else
      new_record_score = false
    end

    # 最新のスコアは毎回保存
    update_recent_score!(params[:score], params[:uid], new_record_score)

    item
  end

  def display_ranking(uid: nil)
    {
      top_ranking: top_ranking(uid),
      high_score: high_score(uid),
      recent_score: recent_score(uid),
    }
  end

  private

  def top_ranking(uid)
    last_rank = nil
    last_score = nil
    rank_items.order(score: :desc, updated_at: :asc).limit(MAX_LIST_COUNT).map.with_index do |item, i|
      obj = {
        score: item.score_txt,
        name: item.name,
      }

      # 同着を考慮した順位の算出
      if item.score == last_score
        obj[:rank] = last_rank
      else
        obj[:rank] = i + 1
        last_rank = i + 1
        last_score = item.score
      end

      # プレイヤーのハイスコアだった場合のフラグを追加
      obj[:is_player] = (item.uid == uid)

      obj
    end
  end

  def high_score(uid)
    return {} unless (item = rank_items.find_by(uid:))

    # プレイヤーのハイスコアより高いレコードを取得して順位を算出
    rank = rank_items.where("score > ?", item.score).count + 1

    {
      score: item.score_txt,
      rank: rank,
      name: item.name
    }
  end

  def recent_score(uid)
    item = recent_items.find_by(uid:).extend(Decorator::PointScore)

    return {} unless item

    # プレイヤーの最新スコアより高いレコードを取得して順位を算出
    rank = rank_items.where("score > ?", item.score).count + 1

    {
      score: item.score_txt,
      rank: rank,
      new_record_score: item.new_record_score?
    }
  end

  def update_recent_score!(score, uid, new_record_score)
    recent = recent_items.find_or_initialize_by(uid:)

    recent.update!(score:, uid:, new_record_score:)
  end
end
