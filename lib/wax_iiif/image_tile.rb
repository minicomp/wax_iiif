# require 'mini_magick'
require 'fileutils'

module WaxIiif
  # Class ImageTile is a specific ImageVariant used when generating a
  # stack of tiles suitable for Mirador-style zooming interfaces. Each
  # instance of ImageTile represents a single tile.
  #
  # @author David Newbury <david.newbury@gmail.com>
  #
  class ImageTile < ImageVariant
    # Initializing this
    #
    # @param [Hash] data A Image Data object.
    # @param [WaxIiif::Config] config The configuration object
    # @param [Hash<width: Number, height: Number, x Number, y: Number, xSize: Number, ySize: Number>] tile
    #    A hash of parameters that defines this tile.
    def initialize(data, config, tile)
      @tile = tile
      super(data, config)
    end

    protected

    def resize(_width = nil, _height = nil)
      return if @tile[:width] == 0
      @image = @image.crop @tile[:x], @tile[:y], @tile[:width], @tile[:height]
      @image = @image.thumbnail_image(@tile[:xSize], { height: @tile[:ySize] })
    end

    def region
      "#{@tile[:x]},#{@tile[:y]},#{@tile[:width]},#{@tile[:height]}"
    end

    def filestring
      "/#{region}/#{@tile[:xSize]},/0"
    end
  end
end
