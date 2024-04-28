RSpec.describe Right, type: :model do
  describe 'associations' do
    describe 'mode: :role' do
      it { is_expected.to have_many(:role_rights).dependent(:destroy) }
      it { is_expected.to have_many(:roles).through(:role_rights) }
      it { is_expected.to have_many(:users).through(:roles) }
    end
  end

  describe 'validations' do
    it { is_expected.to allow_value('cars#update').for(:key) }
    it { is_expected.to allow_value('*#*').for(:key) }
    it { is_expected.to allow_value('cars#*').for(:key) }
    it { is_expected.not_to allow_value('cars#update#').for(:key) }
    it { is_expected.not_to allow_value('cars#').for(:key) }
    it { is_expected.not_to allow_value('cars#update#action').for(:key) }
    it { is_expected.not_to allow_value('#action').for(:key) }
    it { is_expected.not_to allow_value('*').for(:key) }
    it { is_expected.to validate_inclusion_of(:key).in_array(described_class.keys) }

    it 'validates uniqueness of key' do
      create(:right, key: 'cars#update')
      expect(build(:right, key: 'cars#update')).not_to be_valid
    end
  end

  describe '.journies' do
    it 'returns all journies of the app' do
      expect(described_class.journies.count).to eq(45)
    end

    it 'they are instances of ActionDispatch::Journey::Route' do
      expect(described_class.journies.first).to be_a(ActionDispatch::Journey::Route)
    end
  end

  describe '.keys' do
    it 'contains cars#update' do
      expect(described_class.keys).to include('cars#update')
    end

    it 'contains posts#like' do
      expect(described_class.keys).to include('posts#like')
    end

    it 'contains *#*' do
      expect(described_class.keys).to include('*#*')
    end

    it 'contains cars#*' do
      expect(described_class.keys).to include('cars#*')
    end
  end

  describe '#controller' do
    it 'returns nil for *#*' do
      right = build(:right, key: '*#*')
      expect(right.controller).to be_nil
    end

    it 'returns CarsController for cars#update' do
      right = build(:right, key: 'cars#update')
      expect(right.controller).to eq(CarsController)
    end
  end

  describe '#journies' do
    it 'returns all journies for *#*' do
      right = build(:right, key: '*#*')
      expect(right.journies).to eq described_class.journies
    end

    it 'returns all journies for cars#*' do
      right = build(:right, key: 'cars#*')
      expect(right.journies).to eq described_class.journies.select { |r| r.defaults[:controller] == 'cars' }
    end

    it 'returns all journies for cars#update' do
      right = build(:right, key: 'cars#update')
      expect(right.journies).to eq described_class.journies.select { |r| r.defaults[:controller] == 'cars' && r.defaults[:action] == 'update' }
    end
  end

  describe '#paths' do
    it 'returns all paths for cars#show' do
      right = build(:right, key: 'cars#show')
      expect(right.paths).to eq [['GET', '/cars/:id']]
    end
  end
end
