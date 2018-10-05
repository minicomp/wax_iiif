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
      #
      def self.split(path, options = {})
        output_dir = options.fetch(:output_dir, '.')
        verbose = options.fetch(:verbose, false)
        puts "processing #{path}" if verbose
        name = File.basename(path, File.extname(path))

        pages = []

        pdf = MiniMagick::Image.open(path)

        pdf.pages.each_with_index do |page, index|
          FileUtils.mkdir_p output_dir unless output_dir == '.'
          page_file_name = "#{output_dir}/#{name}_pdf_page#{index}.jpg"

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

        image_records(pages)
      end

      def self.image_records(pdf_pages)
        records = pdf_pages.map do |img|
          basename = File.basename(img, '.*').to_s
          id = basename.split('_pdf_page').first
          pagenum = basename.split('_pdf_page').last
          WaxIiif::ImageRecord.new(id: id, path: img, page_number: pagenum)
        end

        records.first.is_primary = true
        records[1..-1].each { |r| r.is_primary = false }
        records
      end
    end
  end
end
