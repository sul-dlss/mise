# frozen_string_literal: true

FactoryBot.define do
  factory :resource, class: 'Resource' do
    trait :nested_in do
      parent factory: :resource
    end

    project factory: :project
  end
end
