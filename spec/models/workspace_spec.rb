# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Workspace do
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
end
