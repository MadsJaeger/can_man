desc 'Gem commands for CanMan'
namespace :can_man do
  desc 'Maintaint databse stored rights, i.e. mirror of routes'
  namespace :rights do
    desc 'Maintain rights table'
    task maintain: :environment do
      Right.maintain!
    end

    desc 'Insert missing keys into rights table'
    task insert: :environment do
      Right.auto_insert!
    end

    desc 'Destroy keys that are no longer in the application'
    task destroy: :environment do
      Right.auto_destroy!
    end
  end
end
