FactoryBot.define do
  factory :point_rank_item do
    sequence(:name) { |n| "ユーザー#{n}" }
    sequence(:score) { |n| n * 100 }
    uid { SecureRandom.uuid }
  end
end
