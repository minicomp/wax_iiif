module WaxIiif
  FakeManifest = Struct.new(:id, :type, :label)

  # Class Manifest is an abstraction over the IIIF Manifest, and by extension over the
  # entire Presentation API.  It takes the internal representation of data and converts
  # it into a collection of JSON-LD documents.  Optionally, it also provides the ability
  # to save these files to disk and upload them to Amazon S3.
  #
  # @author David Newbury <david.newbury@gmail.com>
  class Manifest
    # @return [String] The IIIF default type for a manifest.
    TYPE = 'sc:Manifest'.freeze

    include BaseProperties

    #--------------------------------------------------------------------------
    # CONSTRUCTOR
    #--------------------------------------------------------------------------

    # This will initialize a new manifest.
    #
    # @param [Array<ImageRecord>] image_records An array of ImageRecord types
    # @param [<type>] config <description>
    # @param [<type>] opts <description>
    #
    def initialize(image_records, config, opts = {})
      @config = config
      image_records.each do |record|
        raise WaxIiif::Error::InvalidImageData, 'The data provided to the manifest were not ImageRecords' unless record.is_a? ImageRecord
      end

      @primary = image_records.find(&:primary?)

      raise WaxIiif::Error::InvalidImageData, "No 'primary?' was found in the image data." unless @primary
      raise WaxIiif::Error::MultiplePrimaryImages, 'Multiple primary images were found in the image data.' unless image_records.count(&:primary?) == 1

      @id           = generate_id "#{base_id}/manifest"
      @label        = @primary.label       || opts[:label] || ''
      @description  = @primary.description || opts[:description]
      @attribution  = @primary.attribution || opts.fetch(:attribution, nil)
      @logo         = @primary.logo        || opts.fetch(:logo, nil)
      @license      = @primary.license     || opts.fetch(:license, nil)
      @metadata     = @primary.metadata    || opts.fetch(:metadata, nil)

      @sequences = build_sequence(image_records)
    end

    #
    # @return [String]  the JSON-LD representation of the manifest as a string.
    #
    def to_json(*_args)
      obj = base_properties

      obj['thumbnail']        = @primary.variants['thumbnail'].uri
      obj['viewingDirection'] = @primary.viewing_direction
      obj['viewingHint']      = @primary.document? ? 'paged' : 'individuals'
      obj['sequences']        = [@sequences]

      @primary.variants.each { |k, v| obj[k] = v.uri }

      JSON.pretty_generate obj
    end

    # @return [String]
    def base_id
      @primary.manifest_id || @primary.id
    end

    #
    # Save the manifest and all sub-resources to disk, using the
    # paths contained withing the WaxIiif::Config object passed at
    # initialization.
    #
    # Will create the manifest, sequences, canvases, and annotation subobjects.
    #
    # @return [Void]
    #
    def save_all_files_to_disk
      data = JSON.parse(self.to_json)
      save_to_disk(data)
      data['sequences'].each do |sequence|
        save_to_disk(sequence)
        sequence['canvases'].each do |canvas|
          save_to_disk(canvas)
          canvas['images'].each do |annotation|
            save_to_disk(annotation)
          end
        end
      end
      nil
    end

    protected

    #--------------------------------------------------------------------------
    def build_sequence(image_records, opts = {})
      seq_id = generate_id "sequence/#{@primary.id}"

      opts.merge(
        '@id' => seq_id,
        '@type' => SEQUENCE_TYPE,
        'canvases' => image_records.collect { |i| build_canvas(i) }
      )
    end

    #--------------------------------------------------------------------------
    def build_canvas(data)
      canvas_id = generate_id "canvas/#{data.id}"
      obj = {
        '@type' => CANVAS_TYPE,
        '@id' => canvas_id,
        'label' => data.section_label,
        'width' => data.variants['full'].width.floor,
        'height' => data.variants['full'].height.floor,
        'thumbnail' => data.variants['thumbnail'].uri
      }
      obj['images'] = [build_image(data, obj)]

      # handle objects that are less than 1200px on a side by doubling canvas size
      if obj['width'] < MIN_CANVAS_SIZE || obj['height'] < MIN_CANVAS_SIZE
        obj['width'] *= 2
        obj['height'] *= 2
      end
      obj
    end

    #--------------------------------------------------------------------------
    def build_image(data, canvas)
      annotation_id = generate_id "annotation/#{data.id}"
      {
        '@type' => ANNOTATION_TYPE,
        '@id' => annotation_id,
        'motivation' => MOTIVATION,
        'resource' => {
          '@id' => data.variants['full'].uri,
          '@type' => IMAGE_TYPE,
          'format' => data.variants['full'].mime_type || 'image/jpeg',
          'service' => {
            '@context' => WaxIiif::IMAGE_CONTEXT,
            '@id' => data.variants['full'].id,
            'profile' => WaxIiif::LEVEL_0
          },
          'width' => data.variants['full'].width,
          'height' => data.variants['full'].height
        },
        'on' => canvas['@id']
      }
    end
  end
end
