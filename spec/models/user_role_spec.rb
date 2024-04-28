require 'rails_helper'

RSpec.describe UserRole, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user).optional(false) }
    it { is_expected.to belong_to(:role).optional(false) }
  end

  describe 'validations' do
    subject(:user_role) { described_class.new(role: role, user: user) }

    let(:role) { create(:role) }
    let(:user) { create(:user) }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:role_id) }
  end
end
