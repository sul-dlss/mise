# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'workspaces/show' do
  let(:project) { create(:project) }
  let(:workspace) { create(:workspace, project: project) }
  let(:user_authorized) { false }

  before do
    # The view assumes there is at least one user in the db
    create(:user)

    assign :workspace, workspace

    allow(view).to receive(:can?).and_return(user_authorized)

    render
  end

  describe 'feature workspace' do
    context 'when user is not authorized' do
      context 'when project is not published and workspace is not published' do
        it 'does not render the control' do
          expect(rendered).not_to include('Feature workspace')
        end
      end

      context 'when project is published, and workspace is not published' do
        let(:project) { create(:project, :published) }

        it 'does not render the control' do
          expect(rendered).not_to include('Feature workspace')
        end
      end

      context 'when project is not published, and workspace is published' do
        let(:workspace) { create(:workspace, :published, project: project) }

        it 'does not render the control' do
          expect(rendered).not_to include('Feature workspace')
        end
      end

      context 'when project is published, and workspace is published' do
        let(:project) { create(:project, :published) }
        let(:workspace) { create(:workspace, :published, project: project) }

        it 'does not render the control' do
          expect(rendered).not_to include('Feature workspace')
        end
      end
    end

    context 'when user is authorized' do
      let(:user_authorized) { true }

      context 'when project is not published and workspace is not published' do
        it 'does not render the control' do
          expect(rendered).not_to include('Feature workspace')
        end
      end

      context 'when project is published, and workspace is not published' do
        let(:project) { create(:project, :published) }

        it 'does not render the control' do
          expect(rendered).not_to include('Feature workspace')
        end
      end

      context 'when project is not published, and workspace is published' do
        let(:workspace) { create(:workspace, :published, project: project) }

        it 'does not render the control' do
          expect(rendered).not_to include('Feature workspace')
        end
      end

      context 'when project is published, and workspace is published' do
        let(:project) { create(:project, :published) }
        let(:workspace) { create(:workspace, :published, project: project) }

        it 'renders the control' do
          expect(rendered).to include('Feature workspace')
        end
      end
    end
  end
end
