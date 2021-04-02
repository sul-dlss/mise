# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject { described_class.new(user) }

  let(:user) { nil }
  let(:an_existing_resource) { create(:resource, :folder) }

  describe 'an anonymous user' do
    # can't do very much...
    it { is_expected.not_to be_able_to(:read, Resource) }
    it { is_expected.not_to be_able_to(:edit, Resource) }
    it { is_expected.not_to be_able_to(:create, Resource) }
    it { is_expected.not_to be_able_to(:delete, Resource) }
  end

  describe 'some user' do
    let(:user) { create(:user) }
    let(:a_child_of_some_existing_resource) { build(:resource, :nested_in, parent: an_existing_resource) }
    let(:resource_created_by_user) { create(:resource, :folder, :created_by, user: user) }
    let(:nested_resource) { create(:resource, :folder, :nested_in, parent: resource_created_by_user) }

    # ... can manage resources they created
    it { is_expected.to be_able_to(:manage, resource_created_by_user) }

    # ... is maybe able to create resource, but...
    it { is_expected.to be_able_to(:create, Resource) }

    # ... can only create folders at the top level
    it { is_expected.to be_able_to(:create, build(:resource, :folder)) }
    it { is_expected.not_to be_able_to(:create, build(:resource, resource_type: 'not-a-folder')) }

    # ... and not within someone else's resource
    it { is_expected.not_to be_able_to(:create, a_child_of_some_existing_resource) }

    # but anywhere in their own hierarchy is fine.
    it { is_expected.to be_able_to(:create, build(:resource, :nested_in, parent: resource_created_by_user)) }
    it { is_expected.to be_able_to(:create, build(:resource, :nested_in, parent: nested_resource)) }
  end
end
