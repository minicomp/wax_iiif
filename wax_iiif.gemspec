lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'wax_iiif'
  spec.version       = '0.1.1'
  spec.authors       = ['Marii Nyrop', 'David Newbury']
  spec.email         = ['m.nyrop@columbia.edu']
  spec.summary       = 'Minimal IIIF level 0 generator'
  spec.description   = 'Minimal IIIF level 0 generator for use with minicomp/wax'
  spec.homepage      = 'https://github.com/minicomp/wax_iiif'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.metadata['yard.run'] = 'yri'

  spec.add_development_dependency 'dotenv', '~> 2.5'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'simplecov', '~> 0.16'

  spec.add_runtime_dependency 'mini_magick', '~> 4.8'
  spec.add_runtime_dependency 'progress_bar', '~> 1.3.0'
end
