module MissingIndexes
  class MissingIndexes
    attr_accessor :connection, :missing_indexes, :models, :possible_foreign_keys, :possible_missing_indexes, :missing_foreign_keys

    def initialize(base)
      @base = base
      @connection = @base.connection
      @models = retrieve_active_models
      @missing_indexes = build_missing_indexes
      @possible_foreign_keys = find_possible_foreign_keys
      @missing_foreign_keys = build_missing_foreign_keys
    end

    def missing_indexes_for_display
      missing_indexes(:for_display)
    end

    def missing_foreign_keys_for_display
      missing_foreign_keys(:for_display)
    end

    private
    def build_missing_indexes(method = nil)
      build_missing_keys(:find_missing_indexes, method)
    end

    def build_missing_foreign_keys(method = nil)
      build_missing_keys(:find_missing_foreign_keys, method)
    end

    def build_missing_keys(build_method, action_method = nil)
      klass = build_method.to_s.match(/foreign_key/) ? MissingForeignKey : MissingIndex
      base.send(build_method).map do |rails_model, missing_columns|
        missing = klass.new(rails_model, missing_columns)
        action_method ? missing.send(method) : missing
      end
    end
  end

  class MissingIndex
    attr_accessor :rails_model, :missing_index_columns
    def initialize(rails_model)
      @rails_model = rails_model
      @missing_index_columns = []
    end

    def for_display
      [rails_model.table_name, missing_index_columns]
    end

    alias_method :inspect, :for_display

    def for_action
      [rails_model, missing_index_columns]
    end
  end

  class MissingForeignKey
    attr_accessor :rails_model, :missing_foreign_key_columns
    def initialize(rails_model)
      @rails_model = rails_model
      @missing_index_columns = []
    end

    def for_display
      [rails_model.table_name, missing_foreign_key_columns]
    end

    alias_method :inspect, :for_display

    def for_action
      [rails_model, missing_foreign_key_columns]
    end
  end

  end
end
