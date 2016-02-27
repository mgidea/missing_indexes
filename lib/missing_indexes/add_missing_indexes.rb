require_relative 'foreign_keys'
module MissingIndexes
  module AddMissingIndexes
    include MissingIndexes::ForeignKeys
    def add_missing_indexes(table_hash, options = {})
      table_hash.each do |table_model, reference_columns|
        table_model_name = table_model.table_name
        reflections = table_model.reflections
        reference_columns.each do |reference_column|
          if options[:add_foreign_key]
            deal_with_foreign_key(table_model_name, reference_column, reflections, options[:add_foreign_key])
          end
          add_missing_foreign_key_index(table_model_name, reference_column, options.except(:add_foreign_key))
        end
      end
    end

    def add_missing_foreign_key_index(table_model_name, reference_column, options = {})
      if reference_column.match(MissingIndexes::FOREIGN_KEY_REGEX) && !ActiveRecord::Base.connection.index_exists?(table_model_name, reference_column)
        index_name = options[:name] || "index_#{table_model_name}_on_#{reference_column}"
        length = options[:length] || 63

        options[:name] = "#{index_name[0..(length - 4)]}_id" if index_name.length >= length

        raise "must implement an 'add_index' method" if !respond_to?(:add_index) && !(respond_to?(:connection) && connection.respond_to?(:add_index))
        object = respond_to?(:add_index) ? self : connection
        object.send :add_index, table_model_name.to_sym, reference_column.to_sym, options
      end
    end
  end
end
