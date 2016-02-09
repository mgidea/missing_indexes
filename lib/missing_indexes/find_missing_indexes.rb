require_relative 'add_missing_indexes'
module MissingIndexes
  module FindMissingIndexes
    extend ActiveSupport::Concern

    module ClassMethods
      include MissingIndexes::AddMissingIndexes
      def find_missing_indexes(options = {})
        Rails.application.eager_load!
        ActiveRecord::Base.descendants.map do |m|
          result = nil
          if m.table_exists? && !m.table_name.include?('.')
            if id_columns = m.column_names.grep(MissingIndexes::FOREIGN_KEY_REGEX).presence
              if id_columns = id_columns.reject{|rc| ActiveRecord::Base.connection.index_exists?(m.table_name, rc)}.presence
                result = [m, id_columns]
              end
            end
          end
          result
        end.uniq.compact
      end
    end
  end
end
