require 'csv'
require 'json'

require 'wax_iiif/errors'
require 'wax_iiif/base_properties'
require 'wax_iiif/image_record'
require 'wax_iiif/builder'
require 'wax_iiif/manifest'
require 'wax_iiif/config'
require 'wax_iiif/collection'
require 'wax_iiif/image_variant'
require 'wax_iiif/thumbnail'
require 'wax_iiif/image_tile'
require 'wax_iiif/full_image'
require 'wax_iiif/image_info'
require 'wax_iiif/utilities'

# Module WaxIiif is a tool for generating IIIF resources from a set of files.
# It's designed to support the IIIF level 0 profile, and generates entirely static files.
#
# @author David Newbury <david.newbury@gmail.com>
#
module WaxIiif


  #--------------------------------------------------------------------------
  # CONSTANTS
  #--------------------------------------------------------------------------


  # @return [String] The URI of the presentation context for the IIIF V.2
  PRESENTATION_CONTEXT  = 'http://iiif.io/api/presentation/2/context.json'
  # @return [String] The URI of the image context for the IIIF V.2
  IMAGE_CONTEXT         = 'http://iiif.io/api/image/2/context.json'
  # @return [String] The URI of the image protocol for IIIF
  IMAGE_PROTOCOL        = 'http://iiif.io/api/image'
  # @return [String] The URI of the Level 0 profile for the IIIF V.2
  LEVEL_0               = 'http://iiif.io/api/image/2/level0.json'
  # @return [String]  The IIIF default type for a sequence.
  SEQUENCE_TYPE             = 'sc:Sequence'
  # @return [String]  The IIIF default type for a canvas
  CANVAS_TYPE               = 'sc:Canvas'
  # @return [String]  The IIIF default type for a annotation.
  ANNOTATION_TYPE           = 'oa:Annotation'
  # @return [String]  The IIIF default type for an image.
  IMAGE_TYPE                = 'dcterms:Image'
  # @return [String] The default label for a canvas without a specified name.
  MOTIVATION                = 'sc:painting'
  # @return [String] The default label for a canvas without a specified name.
  DEFAULT_CANVAS_LABEL      = 'front'
  # @return [String] The default name for a sequence without a specified name.
  DEFAULT_SEQUENCE_NAME     = 'default'
  # @return [String] The default reading direction for this manifest.
  DEFAULT_VIEWING_DIRECTION = 'left-to-right'
  # @return [Number] The size in pixels below which the canvas will be doubled.
  MIN_CANVAS_SIZE           = 1200


    #--------------------------------------------------------------------------
    # HELPERS
    #--------------------------------------------------------------------------



  # Validates a viewing direction string against the IIIF V.2.0 spec.
  #
  # According to v2 of the IIIF standards, there are only four valid viewing directions:
  # 'left-to-right', 'top-to-bottom”, 'bottom-to-top' , and 'right-to-left'.  This
  #  returns true if the provided direction is one of these, and falst for anything else.
  #
  # @param [String] direction A viewing direction string
  #
  # @return [boolean] Is the provided string a valid viewing direction?
  #
  def self.is_valid_viewing_direction(direction)
    direction == 'left-to-right' ||
    direction == 'top-to-bottom' ||
    direction == 'bottom-to-top' ||
    direction == 'right-to-left'
  end

end
