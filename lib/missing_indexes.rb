require_relative 'missing_indexes/find_missing_indexes'
require_relative 'missing_indexes/add_missing_indexes'
module MissingIndexes
  FOREIGN_KEY_REGEX = /_id$/
  ActiveRecord::Base.send(:include, MissingIndexes::FindMissingIndexes)
  ActiveRecord::Migration.send(:include, MissingIndexes::AddMissingIndexes)
end
