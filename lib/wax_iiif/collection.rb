module WaxIiif
  # Class Collection is an abstraction over the IIIF Collection, which is an aggregation
  # of IIIF manifests.
  #
  # @author David Newbury <david.newbury@gmail.com>
  #
  class Collection
    # @return [String] The IIIF Type for collections
    TYPE = 'sc:Collection'.freeze
    include BaseProperties
    attr_reader :collections, :manifests, :label

    def initialize(config)
      raise WaxIiif::Error::MissingCollectionName if config.collection_label.to_s.empty?

      @config       = config
      @manifests    = []
      @collections  = []
      @label        = @config.collection_label

      self.id       = "collection/#{@label}"
    end

    def add_collection(collection)
      raise WaxIiif::Error::NotACollection unless collection.respond_to?(:type) && collection.type == Collection::TYPE
      @collections.push(collection)
    end

    def add_manifest(manifest)
      raise WaxIiif::Error::NotAManifest unless manifest.respond_to?(:type) && manifest.type == Manifest::TYPE
      @manifests.push(manifest)
    end

    # The JSON representation of this collection in the IIIF-expected format
    #
    #
    # @return [String] The JSON representation as a string
    #
    def to_json(*_args)
      obj = base_properties
      obj['collections'] = collect_object(collections) unless collections.empty?
      obj['manifests'] = collect_object(manifests) unless manifests.empty?
      JSON.pretty_generate obj
    end

    protected

    def collect_object(things)
      things.collect do |thing|
        {
          '@id' => thing.id,
          '@type' => thing.type,
          'label' => thing.label
        }
      end
    end
  end
end
