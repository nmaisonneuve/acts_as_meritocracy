require File.join(File.expand_path(File.dirname(__FILE__)), 'test_helper')

class MeritocracyTest < Test::Unit::TestCase
  def setup
    Vote.delete_all
    User.delete_all
    Item.delete_all


  end

  def test_acts_as_meritocracy_methods
    user1 = User.create!()
    user2 = User.create!()
    user3 = User.create!()
    user4=User.create!()

    item = Item.create!()

    item.submit_vote(user1, 4) #user1 votes for the decision 4,  by default the vote_weight=1
    item.submit_vote(user2, 1, 2) #user2 votes for the decision 1 with a vote_weight=2. A vote_weight=2 means that the voter has a vote equal to 2 normal voters (vote_weight=1)
    item.submit_vote(user1, 1) #user1 can change/update her vote
    item.submit_vote(user3, 2) #user3 vote for decision 2
    item.submit_vote(user4, 3, 5) #user3 vote for decision 2

    assert_equal 9, item.nb_votes

    dist=item.vote_distribution

    assert_equal 3, dist[0].vote
    assert_equal 5, dist[0].freq
    assert_equal 1, dist[1].vote
    assert_equal 3, dist[1].freq

    assert_equal 0.361, item.consensus.round(3) #fleiss kappa taking into account the weight
    assert_equal 0.063, item.consensus("entropy").round(3)


    #everyone agrees
    item2 = Item.create!()
    item2.submit_vote(user1, 1)
    item2.submit_vote(user2, 1, 3)
    item2.submit_vote(user3, 1, 2)
    assert_equal 1, item2.consensus

    #everyone disagrees
    item3 = Item.create!()
    item3.submit_vote(user1, 1)
    item3.submit_vote(user2, 2)


    assert_equal 0.0, item3.consensus #entropy

  end
end
