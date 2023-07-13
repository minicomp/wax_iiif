lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'wax_iiif'
  spec.version       = '0.2.0'
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

  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'

  spec.add_runtime_dependency 'mini_magick'
  spec.add_runtime_dependency 'parallel'
  spec.add_runtime_dependency 'progress_bar'
  spec.add_runtime_dependency 'rainbow'
end
