FactoryBot.define do
  factory :recent_rank_item do
    sequence(:score) { |n| n * 100 }
    uid { SecureRandom.uuid }
  end
end
