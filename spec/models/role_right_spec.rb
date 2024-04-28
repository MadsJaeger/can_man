require 'rails_helper'

RSpec.describe RoleRight, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:role).optional(false) }
    it { is_expected.to belong_to(:right).optional(false) }
  end

  describe 'validations' do
    subject(:role_right) { described_class.new(role: role, right: right) }

    let(:role) { create(:role) }
    let(:right) { create(:right) }

    it { is_expected.to validate_uniqueness_of(:role_id).scoped_to(:right_id) }
  end
end
