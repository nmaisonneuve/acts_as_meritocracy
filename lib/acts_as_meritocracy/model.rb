module ActsAsMeritocracy #:nodoc:

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    # Example:
    #   class User < ActiveRecord::Base
    #     acts_as_meritocracy
    #   end
    def acts_as_meritocracy(options={})

      # TODO trigger action when decision is reliable
      # acts_as_meritocracy {:quorum=>, :min_consensus=>}}
      #adding class attribute
      #class_attribute :_min_votes, :_max_votes, :_consensus, :_status_update_fct
      #self._min_votes=options[:min_votes] || 3
      #self._max_votes=options[:max_votes] || 6
      #self._consensus=options[:consensus] || 0.7
      #self._status_update_fct=options[:on_status_change] || :decision_updated

      has_many :votes, :as => :voteable, :dependent => :destroy
      has_many :voters, :through => :votes
      attr_accessible :voters


      scope :voted_by, lambda { |user|
        joins(:votes).where("votes.voteable_type = ?", self.name).where("votes.voter_id=?", user.id)
      }

      include ActsAsMeritocracy::InstanceMethods
      extend ActsAsMeritocracy::SingletonMethods
    end
  end

  module SingletonMethods

  end

  module InstanceMethods


    def voted_by?(user)
      self.votes.exists?(:voter_id=>user.id)
    end

    # number of votes taking into account (or not) the weight of the vote
    # 1 vote with vote_weight=2 ==>  2 votes
    def nb_votes(weighted=true)
      if (weighted)
        self.votes.sum('vote_weight')
      else
        self.votes.count
      end
    end

    # retrieve the vote distribution
    def vote_distribution
      Vote.select("vote, sum(vote_weight) as freq").where(:voteable_id=>self.id).group(:vote).order("freq DESC")
    end

    #majority vote (get the decision with the higher number of votes)
    def best_decision(tie_method="random")
      best=nil
      tie=[]
      nb_categories=0
      self.vote_distribution.each { |category|
        if ((best.nil?) || (category.freq>best.freq))
          best=category
          tie=[]
          tie<<category
          # managing tie
        elsif (category.freq==best.freq)
          tie<<category
        end
        nb_categories=nb_categories+1
      }

      # tie detected
      if (tie.size>1)
        case (tie_method)
          when "random" then
            tie[rand(tie.size)].vote
          when "nodecision" then
            nil
        end
        # no vote
      elsif (best.nil?)
        nil
        # get the most chosen category
      else
        best.vote
      end
    end

    # Consensus score  using the vote distribubtion
    # very high consensus=1 , very low consensus=0
    # could be used as an indicator to measure the difficulty of users to take collectively a decision
    # 2 methods are proposed
    # - Entropy
    # - Fleiss Kappa taking into account the weight (NOTE: I removed the pb of chance in the computation)
    def consensus(method="kappa")
      consensus= case method
                   when "entropy" then
                     dist=self.vote_distribution
                     nb_votes=dist.inject(0) { |sum, category| sum+category.freq }.to_f
                     h=self.vote_distribution.inject(0) { |h, category|
                       p_j=category.freq.to_f/nb_votes
                       h + p_j*Math.log(p_j)
                     }
                     h=[h, -1].max
                     1+h

                   when "kappa" then
                     dist=self.vote_distribution
                     nb_votes=dist.inject(0) { |sum, category| sum+category.freq }.to_f
                     fact=dist.inject(0) { |fact, category|
                       fact+category.freq**2
                     }
                     (fact-nb_votes)/(nb_votes*(nb_votes-1))
                   else
                     0
                 end
      consensus
    end

    #submit or update the vote of someone
    def submit_vote(user, vote, vote_weight=1)

      #check existence
      v=Vote.where(:voter_id=>user.id, :voteable_id=>self.id, :voteable_type => self.class.name).first

      #if not create new vote
      if (v.nil?)
        v=Vote.create(:voter=>user,
                      :voteable=>self,
                      :vote=>vote,
                      :vote_weight=>vote_weight)
        #modify existing vote
      else
        v.update_attributes(:vote=>vote, :vote_weight=>vote_weight)
      end
      v
    end

    protected

    def trigger_decision
      # if we are enough sure of the decision  we trigger an action
      if (nb_votes>=self.class._min_votes && consensus>self.class._consensus_ratio)
         #we trigger an action
      end
    end
  end
end