require_relative 'add_missing_indexes'
module MissingIndexes
  module FindMissingIndexes
    extend ActiveSupport::Concern

    module ClassMethods
      include MissingIndexes::AddMissingIndexes

      # use this method to access an object that holds information about missing indexes
      # you can query the
      def audit_foreign_keys
        MissingIndexes::MissingIndex.new(ActiveRecord::Base)
      end

      def find_missing_indexes(options = {})
        find_possible_foreign_keys.map do |m|
          if m.reject_foreign_keys_with_index.present?
            [m, m.reject_foreign_keys_with_index]
          end
        end.uniq.compact
      end

      def has_foreign_keys?
        table_exists? && !self.table_name.include?('.') && foreign_keys_array!
      end

      def foreign_keys_array
        column_names.grep(MissingIndexes::FOREIGN_KEY_REGEX)
      end

      def foreign_keys_array!
        foreign_keys_array.presence
      end

      def reject_foreign_keys_with_index
        foreign_keys_array.reject{ |rc| ActiveRecord::Base.connection.index_exists?(self.table_name, rc) }
      end

      def find_possible_foreign_keys
        retrieve_active_models.select(&:has_foreign_keys?)
      end

      def retrieve_active_models
        Rails.application.eager_load!
        ActiveRecord::Base.descendants
      end

      def reject_foreign_keys_with_constraint
        foreign_keys_array.reject{ |rc| ActiveRecord::Base.connection.foreign_keys(self.table_name).detect{ |fk| fk.options[:column] == rc } }
      end

      def find_missing_foreign_keys
        find_possible_foreign_keys.map do |m|
          if m.reject_foreign_keys_with_constraint.present?
            [m, m.reject_foreign_keys_with_constraint]
          end
        end.uniq.compact
      end

    end
  end
end
