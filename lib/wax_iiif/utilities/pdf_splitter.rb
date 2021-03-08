require 'pdf-reader'
require 'vips'

module WaxIiif
  module Utilities
    # Class PdfSplitter is a utility function designed to convert a PDF into a stack of images.
    #
    # @author David Newbury <david.newbury@gmail.com>
    #
    class PdfSplitter
      # Convert a PDF File into a series of JPEG images, one per-page
      #
      # @param [String] path The path to the PDF file
      # @param [Hash] options The configuration hash
      #
      # @return [Array<String>] The paths to the generated files
      def self.split(path, options = {})
        puts "processing #{path}" if options.fetch(:verbose, false)

        name        = File.basename path, File.extname(path)
        output_dir  = "#{options.fetch(:output_dir, '.')}/#{name}"
        n_pages     = PDF::Reader.new(path).page_count
        max_digits  = n_pages.digits.length

        FileUtils.mkdir_p output_dir

        pages = (0...n_pages).map do |i|
          image = Vips::Image.new_from_file(path, page: i)
          file  = "#{output_dir}/#{i.to_s.rjust(max_digits, '0')}.jpg"
          image.write_to_file file
          file
        end
        GC.start
        pages
      end
    end
  end
end
