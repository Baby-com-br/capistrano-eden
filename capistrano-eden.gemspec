# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

#equire 'capistrano-eden/version'

Gem::Specification.new do |gem|
  gem.name          = "capistrano-eden"
# gem.version       = Capistrano::Eden::VERSION
  gem.version       = '0.0.1'
  gem.authors       = ["Marcus Vinicius Ferreira"]
  gem.email         = ["ferreira.mv@gmail.com"]
  gem.description   = "bunch of helpers for capistrano"
  gem.summary       = "Helpers and some defaults, to be used in our deploys."
  gem.homepage      = "https://github.com/Baby-com-br/capistrano-eden"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end

