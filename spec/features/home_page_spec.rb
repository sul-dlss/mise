# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'The home page' do
  let!(:project) do
    create(:project).tap do |project|
      create(:workspace, project: project)
      create(:workspace, :published, project: project)
      create(:workspace, :featured, project: project)
      create(:workspace, :published, :featured, project: project)
    end
  end

  let!(:published_project) do
    create(:project, :published) do |project|
      create(:workspace, project: project)
      create(:workspace, :published, project: project)
      create(:workspace, :featured, project: project)
      create(:workspace, :published, :featured, project: project)
    end
  end

  it 'has links to sign up or log in' do
    visit '/'

    expect(page).to have_content('Mise')
      .and(have_link('Sign up', href: new_user_registration_path))
      .and(have_link('Log in', href: new_user_session_path))
  end

  it 'only shows featured workspaces that are published and featured in published projects' do
    visit '/'

    expect(page).to have_css '.workspace-card', count: '1'
  end
end
