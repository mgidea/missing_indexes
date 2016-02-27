module MissingIndexes
  module ForeignKeys
    def add_missing_foreign_key(from_table, to_table, options = {})
      raise "must implement an 'add_foreign_key' method" if !respond_to?(:add_foreign_key) && !respond_to?(:connection)
      object = respond_to?(:add_foreign_key) ? self : self.connection
      object.send :add_foreign_key, from_table.to_sym, to_table.to_sym, options
    end

    def deal_with_foreign_key(table_model_name, reference_column, reflections, foreign_key_options)
      foreign_key_options = foreign_key_options.is_a?(Hash) ? foreign_key_options : {}

      to_table =  if reflection_model = reflections[reference_column.gsub(MissingIndexes::FOREIGN_KEY_REGEX, "")]
                    reflection_model.table_name
                  else
                    reflections.detect{|key, reflection| reflection.macro == :belongs_to && reflection.foreign_key.to_s == reference_column}.last.try!(:table_name)
                  end

      if !ActiveRecord::Base.connection.foreign_keys(table_model_name).detect{|fk| fk.options[:column] == reference_column}
        foreign_key_options[:column] = reference_column.to_sym
        add_missing_foreign_key(table_model_name, to_table, foreign_key_options)
      end
    end
  end
end
