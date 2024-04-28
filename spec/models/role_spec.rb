require 'rails_helper'

RSpec.describe Role, type: :model do
  subject(:role) { build(:role) }

  describe 'associations' do
    it { is_expected.to have_many(:role_rights).dependent(:destroy) }
    it { is_expected.to have_many(:rights).through(:role_rights) }
    it { is_expected.to have_many(:user_roles).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:user_roles) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_uniqueness_of(:key) }

    {
      'admin' => true,
      'compliance_officer' => true,
      'sales_manager' => true,
      'customer' => true,
      'Customer' => true,
      'CustomerRelation' => true,
      'user_1ax' => true,
      'Invalid key' => false,
      'invalid key' => false,
      '1ewe' => false
    }.each do |key, valid|
      it "key `#{key}` is #{valid ? 'valid' : 'invalid'}" do
        role.key = key
        role.valid?
        expect(role.errors[:key].empty?).to eq(valid)
      end
    end
  end

  describe '#rights=' do
    before :all do
      Right.auto_insert!
    end

    after :all do
      Right.delete_all
    end

    subject(:role) { build(:role) }

    context 'adding rights' do
      before do
        role.rights = %w[*#* cars#*]
      end

      it 'adds two rights' do
        expect(role.role_rights.size).to eq(2)
      end

      it 'saves them' do
        expect { role.save! }.to change { RoleRight.count }.by(2)
      end

      it 'persists the rights' do
        role.save!
        expect(role.rights.map(&:key)).to eq %w[*#* cars#*]
      end
    end

    context 'removing rights' do
      before do
        role.rights = %w[*#* cars#*]
        role.save!
        role.rights = %w[*#*]
      end

      it 'marks right for destruction' do
        expect(role.role_rights.select(&:marked_for_destruction?).size).to eq(1)
      end

      it 'removes the right' do
        role.save!
        expect(role.rights.pluck(:key)).to eq %w[*#*]
      end
    end

    context 'adding and removing rights' do
      before do
        role.rights = %w[*#* cars#*]
        role.save!
        role.rights = %w[*#* users#*]
      end

      it 'adds and removes rights' do
        role.save!
        expect(role.rights.map(&:key)).to eq %w[*#* users#*]
      end
    end

    context 'it accepts only the last given rights' do
      before do
        role.rights = %w[*#* cars#*]
        role.save!
        role.rights = %w[*#* users#*]
        role.rights = %w[*#* posts#*]
      end

      it 'adds only the last given rights' do
        role.save!
        expect(role.rights.map(&:key)).to eq %w[*#* posts#*]
      end
    end
  end
end
