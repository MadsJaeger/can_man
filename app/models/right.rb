# frozen_string_literal: true

##
# A Right is an access permission to perform a certain action on a certain controller. The rights are automatically
# managed by the maintain! method which inserts missing keys and destroys keys that are no longer in the application.
# the key is a string in the format of 'controller#action' or '*#*' for all controllers and actions. A user will have
# many rights through the roles she is assigned to, e.g. the databse defines the access for the user, in contrast to
# code defined access. This grants the admins of the platrofm the ability to change the access of the users on a granular
# level without changing any code.
class Right < ApplicationRecord
  has_many :role_rights, dependent: :destroy
  has_many :roles, through: :role_rights
  has_many :users, through: :roles

  validates :key, format: { with: CanMan::Key::REGEX },
                  inclusion: { in: proc { keys }, on: :create },
                  presence: true,
                  uniqueness: true,
                  allow_blank: false

  class << self
    ##
    # List of ActionDispatch::Journey::Route objects representing all routes in the application with defaults and whose
    # controller is not blank
    def journies
      @journies ||= Rails.application.routes.routes
                         .reject { |r| r.defaults.empty? }
                         .reject { |r| r.defaults[:controller].blank? }
    end

    ##
    # List of controller#action aka keys for all routes in the application
    def keys
      return @keys if @keys

      sls = journies.map(&:defaults).map { |h| "#{h[:controller]}##{h[:action]}" }
      ctr = journies.map(&:defaults).map { |h| "#{h[:controller]}#*" }
      adm = ['*#*']
      @keys = (adm + ctr + sls).uniq
    end

    ##
    # Maintians the rights table by inserting missing keys and deactivating keys that are no longer in the application
    # and activating keys that are back in the application.
    def maintain!
      auto_insert!
      auto_destroy!
    end

    ##
    # Inserts missing keys into the rights table
    def auto_insert!
      create!((keys - pluck(:key)).map { |key| { key: key } })
    end

    ##
    # Activates keys that are back in the application
    def auto_destroy!
      where(key: pluck(:key) - keys).each(&:destroy!)
    end
  end

  ##
  # Returns a CanMan::Key object
  def key
    CanMan::Key.new(self[:key]) if self[:key]
  end

  def controller
    return nil if key.any_controller?
    return nil if key.controller.blank?

    "#{key.controller.camelize}Controller".constantize
  end

  def journies
    @journies ||= if key.any_controller?
                    self.class.journies
                  else
                    self.class.journies.select do |r|
                      r.defaults[:controller] == key.controller
                    end
                  end.select do |r|
                    key.any_action? || r.defaults[:action] == key.action
                  end
  end

  def paths
    journies.map do |route|
      [
        route.verb,
        route.path.spec.to_s.gsub('(.:format)', '')
      ]
    end
  end
end
