# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "wax_iiif"
  spec.version       = "0.0.1"
  spec.authors       = ["Marii Nyrop", "David Newbury"]
  spec.email         = ["m.nyrop@columbia.edu"]
  spec.summary       = "Minimal iiif level 0 generator – i.e. David Newbury's iiif_s3 minus s3."
  spec.description   = ""
  spec.homepage      = "https://github.com/cmoa/iiif_s3"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency 'dotenv'

  spec.add_runtime_dependency "mini_magick", ">= 4.8"
end
