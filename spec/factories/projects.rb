# frozen_string_literal: true

FactoryBot.define do
  factory :project, class: 'Project' do
    trait :with_owner do
      transient do
        user { nil }
      end

      after(:create) do |resource, evaluator|
        evaluator&.user&.add_role :owner, resource
      end
    end

    trait :with_editor do
      transient do
        user { nil }
      end

      after(:create) do |resource, evaluator|
        evaluator&.user&.add_role :editor, resource
      end
    end
  end
end
