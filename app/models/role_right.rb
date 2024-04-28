# frozen_string_literal: true

##
# A join table between Role and Right, many-to-many relation
class RoleRight < ApplicationRecord
  belongs_to :role, optional: false
  belongs_to :right, optional: false

  validates :role_id, uniqueness: { scope: :right_id }, if: -> { role_id.present? && right_id.present? }
end
