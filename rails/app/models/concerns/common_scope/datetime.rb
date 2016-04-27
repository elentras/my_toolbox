module CommonScope::Datetime
    # module ClassMethods
      def self.scopes_for_attr(model, key)
        # TODO: Find a cleaner way to extend models, I hate to use `eval` methods...
        model.class_eval do
          # Add a scope :by_[attribute name]_greater to perform a Greater than or equal query
          scope "by_#{key}_greater".to_sym, -> (param) {
            where(model.arel_table[key.to_sym].gte(param.to_s(:db)))
          }

          # Add a scope :by_[attribute name]_lesser to perform a Lesser than or equal query
          scope "by_#{key}_lesser".to_sym, -> (param) {
            where(model.arel_table[key.to_sym].lte(param.to_s(:db)))
          }

          # Add a scope :not_by_[attribute name] to perform a Lesser than or equal query
          scope "by_#{key}_between".to_sym, -> (min, max) {
            where(model.arel_table[key.to_sym].between?(min.to_s(:db), max.to_s(:db)))
          }

          # Add a scope :by_[attribute name] to perform an exact match
          scope "by_#{key}".to_sym, -> (value) {
            where(model.arel_table[key.to_sym].eq(value.to_s(:db)))
          }
        end
      end
  # end
end
