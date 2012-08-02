# -*- encoding: utf-8 -*-
require File.expand_path('../lib/travis/stalker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dan Sosedoff", "Dylan Egan"]
  gem.email         = ["dan.sosedoff@gmail.com", "dylanegan@gmail.com"]
  gem.description   = %q{Stalk Travis CI builds.}
  gem.summary       = %q{Stalk Travis.}
  gem.homepage      = "https://github.com/dylanegan/travis-stalker"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "travis-stalker"
  gem.require_paths = ["lib"]
  gem.version       = Travis::Stalker::VERSION

  gem.add_dependency "clamp", "~> 0.3.0"
  gem.add_dependency "pusher-client-merman", "~> 0.2"
  gem.add_dependency "rake", "~> 0.9.0"
  gem.add_dependency "scrolls", "~> 0.2.1"
  gem.add_dependency "terminal-notifier", "~> 1.3"
end
