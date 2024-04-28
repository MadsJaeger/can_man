FactoryBot.define do
  factory :role do
    name { Faker::Hipster.unique.word }
    key { 'admin' }
  end
end
