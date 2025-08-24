FactoryBot.define do
  factory :time_rank_item do
    association :ranking_board, factory: :time_ranking_board
    score { rand(1000..100000) }
    name { "test_user" }
    uid { SecureRandom.uuid }
  end
end
