# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject { described_class.new(user) }

  let(:user) { nil }

  describe 'an anonymous user' do
    let(:public_project) { create(:project, :published) }
    let(:workspace) { create(:workspace, project: public_project) }
    let(:public_workspace) { create(:workspace, :published, project: public_project) }

    # can't do very much...
    it { is_expected.not_to be_able_to(:create, Project) }
    it { is_expected.not_to be_able_to(:edit, Resource) }
    it { is_expected.not_to be_able_to(:create, Resource) }
    it { is_expected.not_to be_able_to(:delete, Resource) }

    it { is_expected.to be_able_to(:read, public_project) }
    it { is_expected.to be_able_to(:read, public_workspace) }
    it { is_expected.not_to be_able_to(:read, workspace) }
    it { is_expected.not_to be_able_to(:feature, public_workspace) }
    it { is_expected.not_to be_able_to(:feature, workspace) }
  end

  context 'with a user with the owner role' do
    let(:user) { create(:user) }
    let!(:project) { create(:project, :with_owner, user: user) }
    let!(:another_project) { create(:project) }

    it { is_expected.to be_able_to(:create, Project) }
    it { is_expected.to be_able_to(:manage, project.workspaces.create) }
    it { is_expected.not_to be_able_to(:feature, project.workspaces.create) }
    it { is_expected.to be_able_to(:manage, project.resources.create) }
    it { is_expected.to be_able_to(:manage, project.roles.build(name: 'viewer')) }
    it { is_expected.to be_able_to(:manage, project.roles.build(name: 'editor')) }
    it { is_expected.to be_able_to(:manage, project.roles.build(name: 'manager')) }
    it { is_expected.to be_able_to(:manage, project.roles.build(name: 'owner')) }

    it { is_expected.not_to be_able_to(:manage, another_project.workspaces.create) }
    it { is_expected.not_to be_able_to(:feature, another_project.workspaces.create) }
    it { is_expected.not_to be_able_to(:manage, another_project.resources.create) }
    it { is_expected.not_to be_able_to(:manage, another_project.roles.build(name: 'viewer')) }
  end

  context 'with a user with the editor role' do
    let(:user) { create(:user) }
    let!(:project) { create(:project, :with_editor, user: user) }

    it { is_expected.to be_able_to(:manage, project.roles.build(name: 'viewer')) }
    it { is_expected.to be_able_to(:manage, project.roles.build(name: 'editor')) }
    it { is_expected.not_to be_able_to(:manage, project.roles.build(name: 'manager')) }
    it { is_expected.not_to be_able_to(:manage, project.roles.build(name: 'owner')) }
  end

  context 'with a user with the site_admin role' do
    let(:user) { create(:user, :site_admin) }
    let!(:project) { create(:project, :published) }
    let!(:workspace) { create(:workspace, :published, project: project) }

    it { is_expected.to be_able_to(:create, Project) }
    it { is_expected.to be_able_to(:manage, workspace) }
    it { is_expected.to be_able_to(:feature, workspace) }
    it { is_expected.to be_able_to(:manage, project.resources.create) }
    it { is_expected.to be_able_to(:manage, project.roles.build(name: 'viewer')) }
    it { is_expected.to be_able_to(:manage, project.roles.build(name: 'editor')) }
    it { is_expected.to be_able_to(:manage, project.roles.build(name: 'manager')) }
    it { is_expected.to be_able_to(:manage, project.roles.build(name: 'owner')) }
  end
end
