# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Workspace do
  subject(:workspace) { build(:workspace) }

  describe 'scopes' do
    let!(:favorite_workspace) { create(:workspace, :favorite) }
    let!(:featured_workspace) { create(:workspace, :featured) }
    let!(:published_workspace) { create(:workspace, :published, project: create(:project, :published)) }

    describe '.favorites' do
      subject(:favorites) { described_class.favorites }

      it { is_expected.to include(favorite_workspace) }
      it { is_expected.not_to include(featured_workspace) }
      it { is_expected.not_to include(published_workspace) }
    end

    describe '.featured' do
      subject(:featured) { described_class.featured }

      it { is_expected.not_to include(favorite_workspace) }
      it { is_expected.to include(featured_workspace) }
      it { is_expected.not_to include(published_workspace) }
    end

    describe '.publicly_accessible' do
      subject(:publicly_accessible) { described_class.publicly_accessible }

      it { is_expected.not_to include(favorite_workspace) }
      it { is_expected.not_to include(featured_workspace) }
      it { is_expected.to include(published_workspace) }
    end
  end

  describe '#attributes_for_template' do
    it 'includes the state' do
      expect(workspace.attributes_for_template).to include 'state', 'state_type'
    end

    it 'includes the published flag and description' do
      expect(workspace.attributes_for_template).to include 'published', 'description'
    end

    it 'ignores the featured flag' do
      expect(workspace.attributes_for_template).not_to include 'featured'
    end

    it 'prefixes the title with "Duplicate of"' do
      workspace.title = 'project 1'
      expect(workspace.attributes_for_template).to include 'title' => 'Duplicate of project 1'
    end
  end
end
