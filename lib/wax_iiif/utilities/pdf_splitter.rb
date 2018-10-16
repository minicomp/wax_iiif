require 'mini_magick'

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

        name        = File.basename(path, File.extname(path))
        output_dir  = "#{options.fetch(:output_dir, '.')}/#{name}"
        pages       = []
        pdf         = MiniMagick::Image.open(path)
        max_digits  = pdf.pages.length.digits.length

        pdf.pages.each_with_index do |page, index|
          FileUtils.mkdir_p output_dir
          page_file_name = "#{output_dir}/#{index.to_s.rjust(max_digits, '0')}.jpg"

          MiniMagick::Tool::Convert.new do |convert|
            convert.density('300')
            convert.units('PixelsPerInch')
            convert << page.path
            convert.quality('80')
            convert.colorspace('sRGB')
            convert.interlace('none')
            convert.flatten
            convert << page_file_name
          end
          pages.push(page_file_name)
        end
        GC.start

        pages
      end
    end
  end
end
