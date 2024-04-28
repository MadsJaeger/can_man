require 'rails_helper'

RSpec.describe User, type: :model do
  before :all do
    Right.maintain!
  end

  let(:user) { create(:user) }

  let(:poster) do
    role = create(:role, key: 'poster', name: 'poster')
    role.rights << Right.find_by!(key: 'posts#*')
    role
  end

  let(:cars_index) do
    role = create(:role, key: 'cars_index', name: 'cars_index')
    role.rights << Right.find_by!(key: 'cars#index')
    role
  end

  let(:admin) do
    role = create(:role, key: 'admin', name: 'admin')
    role.rights << Right.find_by!(key: '*#*')
    role
  end

  describe 'associations' do
    it { is_expected.to have_many(:user_roles).dependent(:destroy) }
    it { is_expected.to have_many(:roles).through(:user_roles) }
  end

  describe '#right_keys' do
    it 'is empty by default' do
      expect(subject.right_keys).to eq([])
    end

    describe 'with roles' do
      before do
        user.roles << poster
        user.roles << cars_index
        user.roles << admin
      end

      it 'returns keys of all rights' do
        expect(user.right_keys).to eq(['*#*', 'cars#index', 'posts#*'])
      end

      it 'may be set' do
        user.right_keys = ['*#*']
        expect(user.right_keys).to eq(['*#*'])
      end
    end
  end

  describe '#has_right?' do
    {
      '*#*' => { admin: true, cars_index: false, poster: false },
      'cars#index' => { admin: true, cars_index: true, poster: false },
      'posts#show' => { admin: true, cars_index: false, poster: true },
      'posts#update' => { admin: true, cars_index: false, poster: true },
      'cars#show' => { admin: true, cars_index: false, poster: false },
      'funky#route' => { admin: true, cars_index: false, poster: false },
    }.each do |route, data|
      data.each do |role, expected|
        it "returns false on #{route} without any role" do
          expect(user.has_right?(route)).to be false
        end

        it "returns #{expected} with role #{role} on #{route}" do
          user.roles << send(role)
          expect(user.has_right?(route)).to be expected
        end
      end
    end
  end

  describe '#role_keys' do
    it 'is empty by default' do
      expect(subject.role_keys).to eq([])
    end

    describe 'with roles' do
      before do
        user.roles << poster
        user.roles << cars_index
        user.roles << admin
      end

      it 'returns keys of all roles' do
        expect(user.role_keys).to eq(%w[admin cars_index poster])
      end

      it 'may be set' do
        user.role_keys = %w[admin]
        expect(user.role_keys).to eq(%w[admin])
      end
    end
  end

  describe '#has_role?' do
    it 'returns false without any role' do
      expect(user.has_role?('admin')).to be false
    end

    it 'returns true with role' do
      user.roles << admin
      expect(user.has_role?(:admin)).to be true
    end
  end

  describe '#roles=' do
    before do
      admin; cars_index; poster
    end

    it 'adds roles' do
      user.update(roles: %w[admin cars_index])
      expect(user.roles).to eq([admin, cars_index])
    end

    it 'removes roles' do
      user.update(roles: 'admin')
      user.update(roles: %w[cars_index poster])
      expect(user.roles).to eq([cars_index, poster])
    end
  end

  after :all do
    Right.delete_all
  end
end
