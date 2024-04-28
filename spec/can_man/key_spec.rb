# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CanMan::Key do
  describe '.new' do
    it 'sets the string' do
      expect(described_class.new('foo#bar')).to eq('foo#bar')
    end

    it 'sets the controller and action' do
      expect(described_class.new(controller: 'foo', action: 'bar')).to eq('foo#bar')
    end
  end

  describe '#controller' do
    it 'returns the controller' do
      expect(described_class.new('foo#bar').controller).to eq('foo')
    end
  end

  describe '#action' do
    it 'returns the action' do
      expect(described_class.new('foo#bar').action).to eq('bar')
    end
  end

  describe '#any_action?' do
    it 'returns true when the action is *' do
      expect(described_class.new('foo#*').any_action?).to be_truthy
    end

    it 'returns false when the action is not *' do
      expect(described_class.new('foo#bar').any_action?).to be_falsey
    end
  end

  describe '#any_controller?' do
    it 'returns true when the controller is *' do
      expect(described_class.new('*#bar').any_controller?).to be_truthy
    end

    it 'returns false when the controller is not *' do
      expect(described_class.new('foo#bar').any_controller?).to be_falsey
    end
  end
end
