# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject { described_class.new(user) }

  let(:user) { nil }
  let(:an_existing_resource) { create(:resource, :folder) }

  describe 'an anonymous user' do
    # can't do very much...
    it { is_expected.not_to be_able_to(:create, Project) }
    it { is_expected.not_to be_able_to(:read, Resource) }
    it { is_expected.not_to be_able_to(:edit, Resource) }
    it { is_expected.not_to be_able_to(:create, Resource) }
    it { is_expected.not_to be_able_to(:delete, Resource) }
  end

  describe 'some user' do
    let(:user) { create(:user) }
    let!(:project) { create(:project, :with_admin, user: user) }
    let!(:another_project) { create(:project) }

    it { is_expected.to be_able_to(:create, Project) }
    it { is_expected.to be_able_to(:manage, project.workspaces.create) }
    it { is_expected.to be_able_to(:manage, project.resources.create) }

    it { is_expected.not_to be_able_to(:manage, another_project.workspaces.create) }
    it { is_expected.not_to be_able_to(:manage, another_project.resources.create) }
  end
end