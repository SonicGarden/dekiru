# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dekiru/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Akihiro Matsumura"]
  gem.email         = ["matsumura.aki@gmail.com"]
  gem.description   = %q{Usefull helper methods for Ruby on Rails}
  gem.summary       = %q{Usefull helper methods for Ruby on Rails}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "dekiru"
  gem.require_paths = ["lib"]
  gem.version       = Dekiru::VERSION

  gem.add_dependency 'http_accept_language', [">= 2.0.0"]
  gem.add_dependency 'rails'
  gem.add_dependency 'faraday'
  gem.add_dependency 'faraday_middleware'
  gem.add_development_dependency 'rake', [">= 0"]
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock', ['>= 1.19.0']
end
