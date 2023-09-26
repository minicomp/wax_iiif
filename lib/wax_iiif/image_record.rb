module WaxIiif
  # Class ImageRecord provides a data structure for a single image file.
  # It contains information for content from the manifest level down to the
  # specific variants of the images.
  #
  # It has the concept of primary images, which are the first (or only) image
  # in the sequence.  This is the image where much of the top-level metadata is
  # taken from.  Each sequence can only have a single primary image, but that
  # constraint isnt enforced
  #
  # @author David Newbury <david.newbury@gmail.com>
  #
  class ImageRecord
    attr_accessor :manifest_id
    attr_accessor :id
    attr_accessor :label
    attr_accessor :description
    attr_accessor :attribution
    attr_accessor :license
    attr_accessor :metadata

    attr_accessor :logo
    attr_accessor :variants

    attr_writer :section
    attr_writer :section_label
    attr_writer :is_document

    # @param [Hash] opts

    # @option opts [String] :label The human-readable label for all grouped records
    # @option opts [String] :description A longer, human-readable description of the gropued records
    # @option opts [String] :logo A URL pointing to a logo of the institution
    # @option opts [Hash]   :variants A hash of derivative names and sizes
    #
    # @example {thumb: 150}
    def initialize(opts = {})
      opts.each do |key, val|
        self.send("#{key}=", val) if self.methods.include? "#{key}=".to_sym
      end
    end

    # The path to this image.
    #
    # @return [String]
    def image_path
      @path
    end

    def path=(path)
      raise WaxIiif::Error::InvalidImageData, "Path is invalid: '#{path}'" unless path && File.exist?(path)
      @path = path
    end


    # The name of the section this image is contained in.
    # Currently used to id the canvas for this image.
    #
    # defaults to WaxIiif::DEFAULT_CANVAS_LABEL
    #
    # @return [String]
    #
    def section
      @section || DEFAULT_CANVAS_LABEL
    end

    # The label for the section this image is contained in.
    # Currently used to label the canvas for this image.
    #
    # defaults to WaxIiif::DEFAULT_CANVAS_LABEL
    #
    # @return [String]
    #
    def section_label
      @section_label || DEFAULT_CANVAS_LABEL
    end

    # @return [String] The prefered viewing direction for this image.
    #   Will default to WaxIiif::DEFAULT_VIEWING_DIRECTION
    #
    def viewing_direction
      @viewing_direction || DEFAULT_VIEWING_DIRECTION
    end

    def viewing_direction=(dir)
      raise Error::InvalidViewingDirection unless WaxIiif.valid_viewing_direction?(dir)
      @viewing_direction = dir
    end

    # Is this image part of a document, or is it a standalone image (or image sequence)?
    #
    # Currently, the only effects the page viewing hint for the image sequence.
    # This will only have an effect on the primary image for this sequence.
    #
    # @return [Bool]
    #
    def document?
      !!@is_document
    end

    # Is this image the master image for its sequence?
    #
    # Each image sequence has a single image chosen as the primary image for
    # the sequence.  By default, page one is the master image, but another image
    # could be chosen as the master if desired.
    #
    # This is, for instance, the image whose thumbnail is the representation for
    # the entire sequence, and it defined viewing direction and other top-level
    # metadata.
    #
    # @return [Bool]
    #
    def primary?
      !!@is_primary
    end

    # Set this image record as the master record for the sequence
    #
    # @param [Bool] val Is this image the master
    #
    # @return [Bool]
    #
    def is_primary=(val)
      @is_primary = !!val
    end
  end
end
