require 'rails_helper'

RSpec.describe "Api::V1::RankingItems", type: :request do
  let(:project) { create(:project) }
  let(:board) { create(:point_ranking_board, project: project) }

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
      create_list(:point_rank_item, 5, ranking_board: board)
      create(:point_rank_item, ranking_board: board, uid: player_uid, name: "プレイヤーさん", score: 250)
      create(:recent_rank_item, ranking_board: board, uid: player_uid, score: 250, new_record_score: true)
    end

    it "スコア一覧が返却されること" do
      get api_v1_ranking_items_path(params)

      expect(JSON.parse(response.body)).to eq({
        top_ranking: [
          { name: "ユーザー5", rank: 1, score: "500", is_player: false },
          { name: "ユーザー4", rank: 2, score: "400", is_player: false },
          { name: "ユーザー3", rank: 3, score: "300", is_player: false },
          { name: "プレイヤーさん", rank: 4, score: "250", is_player: true },
          { name: "ユーザー2", rank: 5, score: "200", is_player: false },
          { name: "ユーザー1", rank: 6, score: "100", is_player: false },
        ],
        high_score: {
          rank: 4, score: "250", name: "プレイヤーさん"
        },
        recent_score: {
          rank: 4, score: "250", new_record_score: true
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
          score: "100",
          d: "testdigest"
        }
      end

      it { expect { post_score }.to change(PointRankItem, :count).by(1) }
      it { expect { post_score }.to change(RecentRankItem, :count).by(1) }
    end

    context "バリデーションエラーの場合" do
      let(:params) do
        {
          project_code: project.code,
          board_num: board.num,
          uid: SecureRandom.uuid,
          name: "長い名前長い名前◆次郎",
          score: "200",
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
