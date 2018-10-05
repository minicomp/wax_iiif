require_relative 'lib/wax_iiif'

IMAGE_DIR       = './temp/pdf-pages'.freeze
TARGET_DIR      = './temp/iiif'.freeze
PDF             = 'spec/data/test.pdf'.freeze

# split pdf to images
records = WaxIiif::Utilities::PdfSplitter.split(PDF, output_dir: IMAGE_DIR)

# process images
builder = WaxIiif::Builder.new(output_dir: TARGET_DIR, verbose: true)
builder.load(records)
builder.process_data

`rm -r #{IMAGE_DIR}`
