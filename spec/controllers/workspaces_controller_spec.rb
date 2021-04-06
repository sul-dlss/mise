# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkspacesController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, :with_admin, user: user) }
  let(:workspace) { create(:workspace, project: project, title: 'abc', state: { some: 'thing' }) }

  before do
    sign_in user
  end

  describe 'PATCH update' do
    it 'updates the title' do
      expect do
        patch :update, params: { id: workspace.id, workspace: { title: 'xyz' } }
      end.to change { workspace.reload.title }.from('abc').to('xyz')
    end

    it 'deserializes the viewer state' do
      expect do
        patch :update, params: { id: workspace.id, workspace: { state: '{ "a": 1 }' } }
      end.to change { workspace.reload.state.with_indifferent_access }.from({ some: 'thing' }).to({ a: 1 })
    end

    it 'leaves the state unchanged when other parameters change' do
      expect do
        patch :update, params: { id: workspace.id, workspace: { title: 'xyz' } }
      end.not_to(change { workspace.reload.state })
    end
  end
end
