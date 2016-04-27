module CommonScope::String
    # module ClassMethods
      def self.scopes_for_attr(model, key)
        # TODO: Find a cleaner way to extend models, I hate to use `eval` methods...
        model.class_eval do
          # Add a scope :by_[attribute name] to perform a LIKE query
          scope "by_#{key}".to_sym, -> (param) {
            where(model.arel_table[key.to_sym].matches("%#{param}%"))
          }

          # Add a scope :not_by_[attribute name] to perform a NOT LIKE query
          scope "not_by_#{key}".to_sym, -> (param) {
            where(model.arel_table[key.to_sym].does_not_match("%#{param}%"))
          }

          # NOTE: Add start_with and end_with methods
        end
      end
    # end
end
