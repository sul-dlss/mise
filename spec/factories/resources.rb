# frozen_string_literal: true

FactoryBot.define do
  factory :resource, class: 'Resource' do
    trait :nested_in do
      parent factory: :resource
    end

    trait :created_by do
      transient { user { nil } }

      after(:create) do |resource, evaluator|
        evaluator&.user&.add_role :admin, resource
      end
    end

    trait :folder do
      resource_type { 'folder' }
    end
  end
end
