# frozen_string_literal: true

FactoryBot.define do
  factory :annotation, class: 'Annotot::Annotation' do
    project
    uuid { SecureRandom.uuid }
    canvas { 'whatever' }
  end
end
