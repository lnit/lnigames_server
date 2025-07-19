require 'rails_helper'

RSpec.describe "Api::V1::RankingNames", type: :request do
  let(:project) { create(:project) }
  let(:board) { create(:point_ranking_board, project: project) }

  describe "PATCH /api/v1/ranking_name" do
    subject(:patch_name) { patch api_v1_ranking_name_path, params: params }

    before do
      allow(LniGamesAuth).to receive(:valid?).and_return(true)
    end

    let(:player_uid) { SecureRandom.uuid }
    let!(:target_rank_item) { create(:point_rank_item, ranking_board: board, uid: player_uid, name: nil, score: 250) }
    let(:params) do
      {
        project_code: project.code,
        board_num: board.num,
        uid: player_uid,
        name: "テスト◆太郎",
        d: "testdigest"
      }
    end

    it "送信したスコアの名前が更新できること", :aggregate_failures do
      expect { patch_name }.to change{ target_rank_item.reload&.name }.from("").to("テスト◆太郎")
      expect(response).to have_http_status(:no_content)
    end
  end
end
