# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra/chiro_version'

Gem::Specification.new do |spec|
  spec.name          = 'sinatra-chiro'
  spec.version       = Sinatra::Chiro::VERSION
  spec.authors       = ['Richard Nienaber']
  spec.email         = %w(rjnienaber@gmail.com)
  spec.description   = %q{Documents and validates sinatra api requests}
  spec.summary       = %q{An easy way to product self-documenting sinatra apis}
  spec.homepage      = 'https://github.com/rjnienaber/chiro'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/) - %w(.gitignore .rvmrc .travis.yml Gemfile.lock Guardfile)
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_runtime_dependency 'sinatra', '~> 1.4.3'
  spec.add_runtime_dependency 'json', '~> 1.8.0'

  spec.add_development_dependency 'rspec', '~> 2.13.0'
  spec.add_development_dependency 'rake'
end
