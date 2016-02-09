module MissingIndexes
  module AddMissingIndexes
    def add_missing_indexes(table_hash, options = {})
      table_hash.each do |table_model, reference_columns|
        table_model_name = table_model.table_name
        reflections = table_model.reflections
        reference_columns.each do |reference_column|

          if foreign_key_options = options.delete(:foreign_key_options)
            to_table =  if reflection_model_name = reflections[reference_column.gsub(MissingIndexes::FOREIGN_KEY_REGEX, "")]
                          Module.const_get(to_model_name).table_name
                        else
                          reflections.detect{|key, reflection| reflection.macro == :belongs_to && reflection.foreign_key.to_s == reference_column}.last.try!(:table_name)
                        end
            foreign_key_options[:column] = reference_column.to_sym
            add_missing_foreign_key(table_model_name, to_table, foreign_key_options)
          end
          add_missing_foreign_key_index(table_model_name, reference_column, options)
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

    def add_missing_foreign_key(from_table, to_table, options = {})
      raise "must implement an 'add_foreign_key' method" if !respond_to?(:add_foreign_key) && !respond_to?(:connection)
      object = respond_to?(:add_foreign_key) ? self : self.connection
      object.send :add_foreign_key, from_table.to_sym, to_table.to_sym, options
    end
  end
end
