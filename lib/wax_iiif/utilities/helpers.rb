module WaxIiif
  module Utilities
    # Module Helpers provides helper functions.  Which seems logical.
    #
    # Note that these functions require an @config object to exist on the
    # mixed-in class.
    #
    # @author David Newbury <david.newbury@gmail.com>
    #
    module Helpers
      # def self.included(klass)
      #   unless respond_to? :config
      #     raise StandardError, "The helpers have been included in class #{klass}, but #{klass} does not have a @config object."
      #   end
      # end

      # This will generate a valid, escaped URI for an object.
      #
      # This will prepend the standard path and prefix, and will append .json
      # if enabled.
      #
      # @param [String] path The desired ID string
      # @return [String] The generated URI
      def generate_id(path)
        val =  "#{@config.base_url}#{@config.prefix}/#{path}"
        val += '.json' if @config.use_extensions
        val
      end

      # Given an id, generate a path on disk for that id, based on the config file
      #
      # @param [String] id the path to the unique key for the object
      # @return [String] a path within the output dir, with the prefix included
      def generate_build_location(id)
        "#{@config.output_dir}#{@config.prefix}/#{id}"
      end

      # Given an id and a page number, generate a path on disk for an image
      # The path will be based on the config file.
      #
      # @param [String] id the unique key for the object
      # @return [String] a path for the image
      def generate_image_location(id)
        generate_build_location "#{@config.image_directory_name}/#{id}"
      end

      def get_data_path(data)
        data['@id'].gsub(@config.base_url, @config.output_dir)
      end

      def save_to_disk(data)
        path = get_data_path(data)
        data['@context'] ||= WaxIiif::PRESENTATION_CONTEXT
        puts "writing #{path}" if @config.verbose?
        FileUtils.mkdir_p File.dirname(path)
        File.open(path, 'w') do |file|
          file.puts JSON.pretty_generate(data)
        end
      end

      def escape_yaml(str)
        str.gsub(/\A---(.|\n)*?---/, '')
      end
    end
  end
end
