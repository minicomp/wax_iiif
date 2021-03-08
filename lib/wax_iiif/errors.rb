require 'rainbow'

module WaxIiif
  # Module Error collects standard errors for th WaxIiif library.
  module Error
    class WaxIiifError < StandardError
      def initialize(msg = '')
        super(Rainbow(msg).magenta)
      end
    end

    # Class MissingRequirements indicates system dependencies were not found
    class MissingRequirements < WaxIiifError; end
    # Class BlankCSV indicates that a provided CSV has no data.
    class BlankCSV < WaxIiifError; end

    # Class InvalidCSV indicates that there is something wrong with the provided CSV.
    class InvalidCSV < WaxIiifError; end

    # Class MissingCollectionName indicates that the collection provided did not have a label.
    class MissingCollectionName < WaxIiifError; end

    # Class NotACollection indicates that the object provided was not a sc:Collection.
    class NotACollection < WaxIiifError; end

    # Class NotAManifest indicates that the object provided was not a sc:Manifest.
    class NotAManifest < WaxIiifError; end

    # Class InvalidCSV indicates that there is something wrong with the provided Image Data.
    class InvalidImageData < WaxIiifError; end

    # Class InvalidViewingDirection indicates that the direction provided was not a valid viewing direction.
    class InvalidViewingDirection < InvalidImageData; end

    # Class MultiplePrimaryImages indicates that multiple images were tagged as primary for a given manifest.
    class MultiplePrimaryImages < InvalidImageData; end

    # Class NoMasterError indicates that all of the images in a collection are secondary images.
    class NoMasterError < InvalidImageData; end
  end
end
