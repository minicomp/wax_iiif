lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'wax_iiif'
  spec.version       = '0.1.0'
  spec.authors       = ['Marii Nyrop', 'David Newbury']
  spec.email         = ['m.nyrop@columbia.edu']
  spec.summary       = 'Minimal iiif level 0 generator'
  spec.description   = ''
  spec.homepage      = 'https://github.com/mnyrop/wax_iiif'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'

  spec.add_runtime_dependency 'mini_magick', '>= 4.8'
end
