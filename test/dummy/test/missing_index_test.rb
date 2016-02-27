require 'test_helper'

class MissingIndexTest < ActiveSupport::TestCase
  test "ActiveRecord::Base responds to find_missing_indexes" do
    assert ActiveRecord::Base.respond_to?(:find_missing_indexes), true
  end

  test "ActiveRecord::Base responds to add_missing_indexes" do
    assert ActiveRecord::Base.respond_to?(:add_missing_indexes), true
  end

  test "ActiveRecord::Base responds to add_missing_foreign_key_index" do
    assert ActiveRecord::Base.respond_to?(:add_missing_foreign_key_index), true
  end

  test "ActiveRecord::Base responds to add_missing_foreign_key" do
    assert ActiveRecord::Base.respond_to?(:add_missing_foreign_key), true
  end

  test "ActiveRecord::Migration.new responds to add_missing_indexes" do
    assert ActiveRecord::Migration.new.respond_to?(:add_missing_indexes), true
  end

  test "ActiveRecord::Migration.new responds to add_missing_foreign_key_index" do
    assert ActiveRecord::Migration.new.respond_to?(:add_missing_foreign_key_index), true
  end

  test "ActiveRecord::Migration.new responds to add_missing_foreign_key" do
    assert ActiveRecord::Migration.new.respond_to?(:add_missing_foreign_key), true
  end

  test "find_missing_indexes" do
    assert ActiveRecord::Base.find_missing_indexes.size == 2, true
  end

  test "add_missing_indexes" do
    missing_indexes = ActiveRecord::Base.find_missing_indexes
    missing_indexes_size = missing_indexes.size

    ActiveRecord::Base.add_missing_indexes(missing_indexes)
    new_missing_indexes = ActiveRecord::Base.find_missing_indexes

    assert new_missing_indexes.size == 0, true
    assert new_missing_indexes.size != missing_indexes_size, true
  end

  test "add_missing_indexes with foreign_key" do
    missing_indexes = ActiveRecord::Base.find_missing_indexes
    connection = ActiveRecord::Base.connection
    tables = ActiveRecord::Base.descendants
    foreign_keys = tables.flat_map{|m| connection.foreign_keys(m.table_name)}

    assert foreign_keys.size == 1, true

    ActiveRecord::Base.add_missing_indexes(missing_indexes, :add_foreign_key => true)

    assert ActiveRecord::Base.find_missing_indexes.size == 0, true

    new_foreign_keys = tables.flat_map{|m| connection.foreign_keys(m.table_name)}

    assert new_foreign_keys.size != foreign_keys.size, true
    assert new_foreign_keys.size == 3, true
  end
end
