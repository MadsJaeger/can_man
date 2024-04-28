# frozen_string_literal: true

class User < ApplicationRecord
  include CanMan::UserRights

  validates :name, :email, presence: true
end
