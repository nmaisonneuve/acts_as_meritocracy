class ActsAsTaggableOnMigration < ActiveRecord::Migration

  def self.up
    create_table :votes, :force => true do |t|
      t.integer :voter_id, :limit => 11
      t.references :voteable, :polymorphic=>true
      t.integer :vote_weight, :default=>1
      t.integer :vote, :default=>1
      t.datetime :updated_at
      t.datetime :created_at
    end
    add_index :votes, :tag_id
    add_index :votes, [:voteable_id, :voteable_type]
  end

  def self.down
    drop_table :votes
  end

end