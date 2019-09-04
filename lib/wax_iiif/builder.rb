require_relative 'utilities'

require 'pathname'
require 'progress_bar'
require 'parallel'

module WaxIiif
  # Builder class
  class Builder
    include Utilities::Helpers

    HEADER_VAL = 'filename'.freeze

    #
    # @!attribute [r] data
    #   @return [Array<Hash>] The raw data computed for the given set of images
    attr_reader :data

    #
    # @!attribute [r] manifests
    #   @return [Array<Hash>] The manifest hashes for this configuration
    attr_accessor :manifests

    # @!attribute [r] config
    #   @return [WaxIiif::Config] The configuration object
    attr_reader :config

    # Initialize the builder.
    #
    # @param [Hash] config an optional configuration object.
    # @see WaxIiif::Config
    # @return [Void]
    #
    def initialize(config = {})
      @manifests = []
      @config = WaxIiif::Config.new(config)
    end

    #
    # Load data into the IIIF builder.
    #
    # This will load the data, perform some basic verifications on it, and sort
    # it into proper order.
    #
    # @param [Array<ImageRecord>, ImageRecord] data
    #   Either a single ImageRecord or an Array of ImageRecords.
    # @raise [WaxIiif::Error::InvalidImageData] if any of the data does
    #   not pass the validation checks
    #
    # @return [Void]
    #
    def load(data)
      @data = [data].flatten # handle hashes and arrays of hashes
      # validate
      @data.each do |image_record|
        raise WaxIiif::Error::InvalidImageData, "Image record #{image_record.inspect} is not an ImageRecord" unless image_record.is_a? ImageRecord
        raise WaxIiif::Error::InvalidImageData, "Image record #{image_record.inspect} does not have an ID" if image_record.id.nil?
      end
    end

    #
    # Take the loaded data and generate all the files.
    #
    # @param [Integer] thread_count Thread count to use for processing images concurrently. Defaults to number of processors.
    #
    # @return [Void]
    #
    def process_data(thread_count: Parallel.processor_count)
      puts Rainbow("Running on #{thread_count} threads.").blue

      return nil if @data.nil? # do nothing without data.

      @manifests = []

      data = @data.group_by(&:manifest_id)
      bar = ProgressBar.new(data.length)
      bar.write

      data.each do |key, value|
        manifest_id   = key
        image_records = value
        resources     = process_image_records(image_records,
                                              thread_count: thread_count)

        # Generate the manifest
        if manifest_id.to_s.empty?
          resources.each do |_key, val|
            manifests.push generate_manifest(val, @config)
          end
        else
          manifests.push generate_manifest(image_records, @config)
        end

        bar.increment!
        bar.write
      end

      generate_collection
    end

    def generate_collection
      collection = Collection.new(@config)
      manifests.each { |m| collection.add_manifest(m) }
      collection.save
    end

    # Creates the required directories for exporting to the file system.
    #
    # @return [Void]
    def create_build_directories
      root_dir = generate_build_location('')
      Dir.mkdir root_dir unless Dir.exist?(root_dir)
      img_dir = generate_image_location('').split('/')[0...-1].join('/')
      Dir.mkdir img_dir unless Dir.exist?(img_dir)
    end

    # Load data into the IIIF server from a CSV
    #
    # @param [String] csv_path Path to the CSV file containing the image data
    #
    # @return [Void]
    # @todo Fix this to use the correct data format!
    #
    def load_csv(csv_path)
      raise Error::InvalidCSV unless File.exist? csv_path
      begin
        vals = CSV.read(csv_path)
      rescue CSV::MalformedCSVError
        raise Error::InvalidCSV
      end

      raise Error::BlankCSV if vals.length.zero?
      raise Error::InvalidCSV if vals[0].length != 3

      # remove optional header
      vals.shift if vals[0][0] == HEADER_VAL

      @data = vals.collect { |d| { 'image_path' => d[0], 'id' => d[1], 'label' => d[2] } }
    end

    protected

    #----------------------------------------------------------------
    def load_variants(path)
      data  = JSON.parse escape_yaml(File.read(path))
      id    = data['@id']
      w     = data['width']
      h     = data['height']

      thumb_size = data['sizes'].find do |a|
        same_width  = a['width']  == config.thumbnail_size
        same_height = a['height'] == config.thumbnail_size
        same_width || same_height
      end

      thumb_w   = thumb_size['width']
      thumb_h   = thumb_size['height']
      full_url  = "#{id}/full/full/0/default.jpg"
      thumb_url = "#{id}/full/#{thumb_w},/0/default.jpg"
      full      = FakeImageVariant.new(id,
                                       w,
                                       h,
                                       full_url,
                                       'image/jpeg')
      thumbnail = FakeImageVariant.new(id,
                                       thumb_w,
                                       thumb_h,
                                       thumb_url,
                                       'image/jpeg')

      { 'full' => full, 'thumbnail' => thumbnail }
    end

    def generate_tiles(data, config)
      width = data.variants['full'].width
      tile_width = config.tile_width
      height = data.variants['full'].height
      tiles = []
      config.tile_scale_factors.each do |s|
        (0..(height * 1.0 / (tile_width * s)).floor).each do |tile_y|
          (0..(width * 1.0 / (tile_width * s)).floor).each do |tile_x|
            tile = {
              scale_factor: s,
              xpos: tile_x,
              ypos: tile_y,
              x: tile_x * tile_width * s,
              y: tile_y * tile_width * s,
              width: tile_width * s,
              height: tile_width * s,
              xSize: tile_width,
              ySize: tile_width
            }
            if tile[:x] + tile[:width] > width
              tile[:width] = width - tile[:x]
              tile[:xSize] = (tile[:width] / (s * 1.0)).ceil
            end
            if tile[:y] + tile[:height] > height
              tile[:height] = height - tile[:y]
              tile[:ySize]  = (tile[:height] / (s * 1.0)).ceil
            end
            tiles.push(tile)
          end
        end
      end
      tiles.each do |tile|
        ImageTile.new(data, @config, tile)
      end
    end

    def image_info_file_name(data)
      "#{generate_image_location(data.id)}/info.json"
    end

    def generate_image_json(data, config)
      filename = image_info_file_name(data)
      info = ImageInfo.new(data.variants['full'].id,
                           data.variants,
                           config.tile_width,
                           config.tile_scale_factors)
      puts "writing #{filename}" if config.verbose?
      Pathname.new(Pathname.new(filename).dirname).mkpath
      File.open(filename, 'w') { |file| file.puts info.to_json }
      info
    end

    def generate_manifest(data, config)
      m = Manifest.new(data, config)
      m.save_all_files_to_disk
      m
    end

    def generate_variants(data, config)
      obj = {
        'full' => FullImage.new(data, config),
        'thumbnail' => Thumbnail.new(data, config)
      }
      config.variants.each do |key, image_size|
        obj[key] = ImageVariant.new(data, config, image_size)
      end
      obj
    end

    def process_image_records(image_records,
                              thread_count: Parallel.processor_count)
      resources = {}

      # genrate the images
      Parallel.each(image_records, in_threads: thread_count) do |image_record|
        # It attempts to load the info files and skip generation - not currently working.
        info_file = image_info_file_name(image_record)
        if File.exist?(info_file)
          puts "skipping #{info_file}" if @config.verbose?
          image_record.variants = load_variants(info_file)
        else
          image_record.variants = generate_variants(image_record, @config)
          generate_tiles(image_record, @config)
          generate_image_json(image_record, @config)
        end
        # Save the image info for the manifest
        resources[image_record.id] ||= []
        resources[image_record.id].push image_record
      end

      resources
    end
  end
end
