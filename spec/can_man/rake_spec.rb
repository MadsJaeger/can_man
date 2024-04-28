require 'rails_helper'
Rails.application.load_tasks

RSpec.describe 'CanMan::Rake' do
  describe 'rights:insert' do
    it 'inserts missing keys into rights table' do
      expect { Rake::Task['can_man:rights:insert'].invoke }.to change { Right.count }.by(58)
    end

    it 'does not insert existing keys into rights table' do
      Rake::Task['can_man:rights:insert'].invoke
      expect { Rake::Task['can_man:rights:insert'].invoke }.to change { Right.count }.by(0)
    end
  end

  describe 'rights:destroy' do
    before do
      hound = build(:right, key: 'hounds#create')
      hound.save(validate: false)
    end

    it 'deactivates keys that are no longer in the application' do
      expect do
        Rake::Task['can_man:rights:destroy'].invoke
      end.to change(Right, :count).by(-1)
    end
  end

  describe 'rights:maintain' do
    it 'inserts missing keys into rights table' do
      expect { Rake::Task['can_man:rights:maintain'].invoke }.to change { Right.count }.by(58)
    end
  end
end
