require 'action_view'
require 'sprockets'

module ActionView
  module Helpers

    module AssetTagHelper
      def javascript_include_tag_with_sprockets(*sources)
        sprocketized_sources = sources.map do |source|
          source = source.gsub(/^\/assets\//, "")
          source = source.gsub(/\.js$/, "")
          if source.kind_of? String and !Assets[source].nil?
            digest = Assets[source].digest
            "/assets/#{source}.js?#{digest}"
          else
            source
          end
        end
        javascript_include_tag_without_sprockets(*sprocketized_sources)
      end

      alias_method_chain :javascript_include_tag, :sprockets

      private

      def path_to_stylesheet_with_sprockets(source)
        source = source.gsub(/^\/assets\//, "")
        source = source.gsub(/\.css$/, "")
        source = if source.kind_of? String and Assets["#{source}.css"].present?
                   digest = Assets["#{source}.css"].digest
                   "/assets/#{source}.css?#{digest}"
                 else
                   source
                 end
        path_to_stylesheet_without_sprockets(source)
      end

      alias_method_chain :path_to_stylesheet, :sprockets

    end

  end
end