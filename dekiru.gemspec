# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dekiru/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Akihiro Matsumura"]
  gem.email         = ["matsumura.aki@gmail.com"]
  gem.description   = %q{Usefull helper methods for Ruby on Rails}
  gem.summary       = %q{Usefull helper methods for Ruby on Rails}
  gem.homepage      = "https://github.com/SonicGarden/dekiru"

  gem.metadata["homepage_uri"] = gem.homepage
  gem.metadata["source_code_uri"] = "https://github.com/SonicGarden/dekiru"
  gem.metadata["changelog_uri"] = "https://github.com/SonicGarden/dekiru/releases"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "dekiru"
  gem.require_paths = ["lib"]
  gem.version       = Dekiru::VERSION

  gem.required_ruby_version = '>= 3.1.0'

  gem.add_dependency 'rails', '>= 7.0'
  gem.add_dependency 'dekiru-data_migration'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'webmock', '>= 1.19.0'
  gem.add_development_dependency 'byebug'
end
