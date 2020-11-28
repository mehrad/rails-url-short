FactoryBot.define do
  factory :url do
    url { Faker::Internet.url}
  end
end
