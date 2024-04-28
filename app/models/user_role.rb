# frozen_string_literal: true

##
# Join of user and role, many-to-many relation
class UserRole < ApplicationRecord
  belongs_to :user, optional: false
  belongs_to :role, optional: false

  validates :user_id, uniqueness: { scope: :role_id }, if: -> { user_id.present? && role_id.present? }
end
