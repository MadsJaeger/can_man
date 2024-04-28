require_relative 'lib/can_man/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.7.2'
  spec.name        = 'can_man'
  spec.version     = CanMan::VERSION
  spec.authors     = ['Mads Jæger']
  spec.email       = ['madshjaeger@gmail.dk']
  spec.homepage    = 'https://github.com/MadsJaeger/can_man'
  spec.summary     = 'A Rights Based Authorization Gem'
  spec.description = 'A new convention for writing permissions for models, seemlessly integrated in controllers based on a simple role system.'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/changelog"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,spec,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end
  spec.test_files = Dir['spec/**/*']

  spec.add_dependency 'rails', '>= 7.0.5'

  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'rspec-rails', '~> 6.0', '>= 6.0.1'
  spec.add_development_dependency 'shoulda-matchers'
end
