require_relative 'lib/wax_iiif/version'

Gem::Specification.new do |spec|
  spec.name          = 'wax_iiif'
  spec.version       = WaxIiif::VERSION
  spec.authors       = ['Marii Nyrop', 'David Newbury']
  spec.email         = ['marii@nyu.edu']
  spec.summary       = 'Minimal IIIF level 0 generator'
  spec.description   = 'Minimal IIIF level 0 generator for use with minicomp/wax'
  spec.homepage      = 'https://github.com/minicomp/wax_iiif'
  spec.license       = 'MIT'

  spec.required_ruby_version  = '>= 3.0'
  spec.files                  = `git ls-files -z`.split("\x0")
  spec.executables            = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files             = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths          = ['lib']

  spec.requirements << 'libvips'

  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'

  spec.add_runtime_dependency 'ruby-vips'
  spec.add_runtime_dependency 'parallel'
  spec.add_runtime_dependency 'pdf-reader'
  spec.add_runtime_dependency 'rainbow'
end
