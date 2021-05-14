# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }

    trait :site_admin do
      after(:create) { |user| user.add_role(:site_admin) }
    end
  end
end
