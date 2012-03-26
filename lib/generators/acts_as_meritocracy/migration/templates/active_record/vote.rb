
# inspired by thumb_up gem
# https://raw.github.com/brady8/thumbs_up/

class Vote < ActiveRecord::Base

  scope :for_voter, lambda { |*args| where(["voter_id = ?", args.first.id]) }
  scope :for_voteable, lambda { |*args| where(["voteable_id = ? AND voteable_type = ?", args.first.id, args.first.class.base_class.name]) }
  scope :recent, lambda { |*args| where(["created_at > ?", (args.first || 2.weeks.ago)]) }
  scope :descending, order("created_at DESC")

  belongs_to :voteable, :polymorphic => true

  belongs_to :voter, :class_name=>"User"

  attr_accessible :vote, :voter, :voteable, :vote_weight

  # Comment out the line below to allow multiple votes per user.
  validates_uniqueness_of :voteable_id, :scope => [:voteable_type, :voter_id]

end