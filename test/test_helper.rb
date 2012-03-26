require 'test/unit'


$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))


#require 'simplecov'
#SimpleCov.start

require 'active_record'
require 'logger'


TEST_DATABASE_FILE = File.join(File.dirname(__FILE__), '..', 'test.sqlite3')
File.unlink(TEST_DATABASE_FILE) if File.exist?(TEST_DATABASE_FILE)
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => TEST_DATABASE_FILE

ActiveRecord::Migration.verbose = true
#ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Schema.define do

  create_table :votes, :force => true do |t|
    t.integer :voter_id, :default => false
    t.integer :vote, :default => false
    t.references :voteable, :polymorphic => true, :null => false
    t.integer :vote_weight, :default=>1
    t.timestamps
  end

  create_table :users, :force => true do |t|
    t.timestamps
  end

  create_table :items, :force => true do |t|
  end
end


require 'acts_as_meritocracy'

class User < ActiveRecord::Base
end


class Vote < ActiveRecord::Base
  belongs_to :voteable, :polymorphic => true
  belongs_to :voter, :class_name=>"User"
  attr_accessible :vote, :voter, :voteable, :vote_weight

  # Comment out the line below to allow multiple votes per user.
  validates_uniqueness_of :voteable_id, :scope => [:voteable_type, :voter_id]
end

class Item < ActiveRecord::Base
  acts_as_meritocracy
end


class Test::Unit::TestCase
end
