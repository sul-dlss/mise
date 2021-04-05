# frozen_string_literal: true

FactoryBot.define do
  factory :project, class: 'Project' do
    trait :with_admin do
      transient do
        user { nil }
      end

      after(:create) do |resource, evaluator|
        evaluator&.user&.add_role :admin, resource
      end
    end
  end
end
