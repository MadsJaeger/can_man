# frozen_string_literal: true

##
# A named grouping of rights. Roles are intended to be created for maningfull concepts like: sales_manger,
# compliance_officer, public, admin, etc. As a naming of rights that are restricted to users who serves that funciton.
# It may be wise to create one or few base roles that has many rights that are common for most users. And restrictive
# rights grouped in more specific roles: admin, right_manager, user_manager, etc.
class Role < ApplicationRecord
  # To validate that the key looks like a symbol. It should start with a letter and contain only letters, numbers,
  # and underscores.
  SYMBOLIC_REGEX = /\A[a-z]\w*\z/i

  has_many :role_rights, dependent: :destroy, autosave: true
  has_many :rights, through: :role_rights
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  validates :key, uniqueness: true, presence: true, format: { with: SYMBOLIC_REGEX }

  def rights=(keys)
    role_rights.reload

    current = rights.pluck(:key)
    new_keys = [keys].flatten.compact.map(&:to_s).sort

    build_role_rights_for(new_keys - current)
    mark_role_rights_for_destruction_for(current - new_keys)

    rights.reset
  end

  private

  def build_role_rights_for(keys)
    Right.where(key: keys).find_each do |right|
      role_rights.build(right: right)
    end
  end

  def mark_role_rights_for_destruction_for(keys)
    right_ids = rights.where(key: keys).pluck(:id)
    role_rights.each do |role_right|
      role_right.mark_for_destruction if right_ids.include? role_right.right_id
    end
  end
end
