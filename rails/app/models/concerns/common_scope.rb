require 'common_scope/date'
require 'common_scope/datetime'
require 'common_scope/integer'
require 'common_scope/string'

module CommonScope
  extend ActiveSupport::Concern

  TYPES_HANDLED = %w(String).freeze
  # TYPES_HANDLED = %w(Integer Date Datetime String).freeze

  def self.included(base)
    base.extend ClassMethods
    base.define_scopes
  end

  module ClassMethods

    def define_scopes
      columns_hash.each do |key, info|
        next unless TYPES_HANDLED.include?(info.type)
        type = info.type.capitalize.constantize
        type.scopes_for_attr(self, key)
      end
    end

  end

end
