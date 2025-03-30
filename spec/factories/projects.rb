FactoryBot.define do
  factory :project do
    sequence(:code) { |n| "Project#{n}" }
  end
end
