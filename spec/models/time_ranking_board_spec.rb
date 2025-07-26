require 'rails_helper'

RSpec.describe TimeRankingBoard, type: :model do
  let(:ranking_board) { create(:time_ranking_board) }

  describe "#add_item!" do
    let(:params) { { uid: "test_uid", score: 1000, name: "test_user" } }

    context "when new record" do
      it "creates a new rank item" do
        expect { ranking_board.add_item!(params) }.to change { TimeRankItem.count }.by(1)
      end
    end

    context "when score is lower than existing record" do
      before do
        ranking_board.add_item!(params.merge(score: 2000))
      end

      it "updates the rank item" do
        expect { ranking_board.add_item!(params) }.to change { ranking_board.rank_items.find_by(uid: params[:uid]).score }.from(2000).to(1000)
      end
    end

    context "when score is higher than existing record" do
      before do
        ranking_board.add_item!(params)
      end

      it "does not update the rank item" do
        expect { ranking_board.add_item!(params.merge(score: 2000)) }.not_to change { ranking_board.rank_items.find_by(uid: params[:uid]).score }
      end
    end
  end
end
