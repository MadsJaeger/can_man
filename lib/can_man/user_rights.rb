# frozen_string_literal: true

module CanMan
  ##
  # This module is to be included in the User model granting the users relation to rights
  module UserRights
    def self.included(base)
      base.class_eval do
        has_many :user_roles, dependent: :destroy, autosave: true
        has_many :roles, through: :user_roles
        has_many :rights, -> { distinct }, through: :roles
      end
    end

    ##
    # Returns the right_keys for the user, i.e. list of controller#action.
    def right_keys
      @right_keys || rights.map(&:key).sort
    end

    ##
    # Sets the right_keys for the user, i.e. list of controller#action. stored as instance variable allowing it to be
    # cached without hitting the database. Useful in a JWT setup where the jwt contains the right_keys and user is
    # initialized from the jwt.
    def right_keys=(array_of_keys)
      @right_keys = Array.new(array_of_keys).flatten.compact.map do |key|
        Key.new(key)
      end
    end

    ##
    # Does the user have the right to perform the given key, i.e. controller#action
    def has_right?(key)
      cey = Key.new(key)
      return true if right_keys.include?('*#*')
      return true if right_keys.include?("#{cey.controller}#*")

      right_keys.include?(cey)
    end

    ##
    # Returns the keys of the roles of the user
    def role_keys
      @role_keys || roles.map(&:key).sort
    end

    ##
    # Sets the keys of the roles of the user. Stored as instance variable allowing it to be cached without hitting the
    # database. Useful in a JWT setup where the jwt contains the role_keys and user is initialized from the jwt.
    def role_keys=(keys)
      @role_keys = Array.new(keys).flatten.compact.map(&:to_s).sort
    end

    ##
    # Does the user have the role with the given key
    def has_role?(key)
      role_keys.include?(key.to_s)
    end

    ##
    # Build the roles of the user from the given keys. The keys are the keys of the roles. Roles are added if not there
    # allready and removed if not in the given keys.
    def roles=(keys)
      user_roles.reload

      current = role_keys
      new_keys = [keys].flatten.compact.map(&:to_s).sort

      build_user_roles_for(new_keys - current)
      mark_user_roles_for_destruction_for(current - new_keys)

      roles.reset
    end

    private

    def build_user_roles_for(keys)
      Role.where(key: keys).find_each do |role|
        user_roles.build(role: role)
      end
    end

    def mark_user_roles_for_destruction_for(keys)
      role_ids = roles.where(key: keys).pluck(:id)
      user_roles.each do |user_role|
        user_role.mark_for_destruction if role_ids.include? user_role.role_id
      end
    end
  end
end
