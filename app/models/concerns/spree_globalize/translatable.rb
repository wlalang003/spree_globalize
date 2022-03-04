module SpreeGlobalize
  module Translatable
    extend ActiveSupport::Concern

    include Spree::RansackableAttributes

    included do |klass|
      has_many :translations
      accepts_nested_attributes_for :translations
      klass.whitelisted_ransackable_associations ||= []
      klass.whitelisted_ransackable_associations |= ['translations']
    end

    class_methods do
      def ransack(params = {}, options = {})
        params ||= {}
        names = params.keys

        names.each do |n|
          translated_attribute_names.each do |t|
            if n.to_s.starts_with? t.to_s
              params[:"translations_#{n}"] = params[n]
              params.delete n
            end
          end
        end

        super(params, options)
      end

      def json_api_columns
        d = column_names
        if self.respond_to?(:translated_attribute_names)
          d += self.translated_attribute_names.map(&:to_s)
        end
        d.reject { |c| c.match(/_id$|id|preferences|(.*)password|(.*)token|(.*)api_key/) }
      end

      alias :search :ransack unless respond_to? :search

      # preload translations
      def spree_base_scopes
        super.includes(:translations).references(:translations)
      end
    end
  end
end
