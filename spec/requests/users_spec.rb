require 'rails_helper'

RSpec.describe '/users (routes CanMan::Constraint)', type: :request do
  before do
    allow_any_instance_of(CanMan::Constraint).to receive(:current_user).and_return(user)
  end

  let(:user) { create(:user) }

  it 'fails' do
    get users_path
  end

  pending 'finalize spec'
end
