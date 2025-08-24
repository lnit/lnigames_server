require 'rails_helper'

RSpec.describe "Api::V1::RankingItems", type: :request do
  let(:project) { create(:project) }
  let(:board) { create(:time_ranking_board, project: project) }

  describe "GET /api/v1/ranking_items" do
    let(:player_uid) { SecureRandom.uuid }
    let(:params) do
      {
        project_code: project.code,
        board_num: board.num,
        uid: player_uid,
      }
    end

    before do
      # スコアが低い順に並ぶように調整
      create(:time_rank_item, ranking_board: board, name: "ユーザー1", score: 100123) # 1分40秒123ミリ秒
      create(:time_rank_item, ranking_board: board, name: "ユーザー2", score: 200456) # 3分20秒456ミリ秒
      create(:time_rank_item, ranking_board: board, name: "ユーザー3", score: 300789) # 5分00秒789ミリ秒
      create(:time_rank_item, ranking_board: board, name: "ユーザー4", score: 400000) # 6分40秒000ミリ秒
      create(:time_rank_item, ranking_board: board, name: "ユーザー5", score: 500000) # 8分20秒000ミリ秒
      create(:time_rank_item, ranking_board: board, uid: player_uid, name: "プレイヤーさん", score: 250999) # 4分10秒999ミリ秒
      create(:recent_rank_item, ranking_board: board, uid: player_uid, score: 250999, new_record_score: true)
    end

    it "スコア一覧が小数点以下まで正しく返却されること" do
      get api_v1_ranking_items_path(params)

      expect(JSON.parse(response.body)).to eq({
        top_ranking: [
          { name: "ユーザー1", rank: 1, score: "01:40.123", is_player: false },
          { name: "ユーザー2", rank: 2, score: "03:20.456", is_player: false },
          { name: "プレイヤーさん", rank: 3, score: "04:10.999", is_player: true },
          { name: "ユーザー3", rank: 4, score: "05:00.789", is_player: false },
          { name: "ユーザー4", rank: 5, score: "06:40.000", is_player: false },
          { name: "ユーザー5", rank: 6, score: "08:20.000", is_player: false },
        ],
        high_score: {
          rank: 3, score: "04:10.999", name: "プレイヤーさん"
        },
        recent_score: {
          rank: 3, score: "04:10.999", new_record_score: true
        },
      }.as_json)
    end
  end

  describe "POST /api/v1/ranking_items" do
    subject(:post_score) { post api_v1_ranking_items_path, params: params }

    before do
      allow(LniGamesAuth).to receive(:valid?).and_return(true)
    end

    context "正当なリクエストの場合" do
      let(:params) do
        {
          project_code: project.code,
          board_num: board.num,
          uid: SecureRandom.uuid,
          name: "テスト◆太郎",
          score: "100000", # ミリ秒
          d: "testdigest"
        }
      end

      it { expect { post_score }.to change(TimeRankItem, :count).by(1) }
      it { expect { post_score }.to change(RecentRankItem, :count).by(1) }
    end

    context "バリデーションエラーの場合" do
      let(:params) do
        {
          project_code: project.code,
          board_num: board.num,
          uid: SecureRandom.uuid,
          name: "長い名前長い名前◆次郎",
          score: "200000",
          d: "testdigest"
        }
      end

      it "エラーレスポンスが返却されること" do
        post_score

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
