# frozen_string_literal: true

FactoryBot.define do
  factory :workspace, class: 'Workspace' do
    project

    trait :published do
      published { true }
    end

    trait :featured do
      featured { true }
    end

    trait :favorite do
      favorite { true }
    end
  end
end
