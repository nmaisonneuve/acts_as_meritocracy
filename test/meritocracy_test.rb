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

    item = Item.create!()

    item.submit_vote(user1, 2)
    item.submit_vote(user1, 1) #update his vote
    item.submit_vote(user2, 1, 3)
    item.submit_vote(user3, 2, 2)

    assert_equal 6, item.nb_votes

    dist=item.vote_distribution

    assert_equal 1, dist[0].vote
    assert_equal 4, dist[0].freq
    assert_equal 2, dist[1].vote
    assert_equal 2, dist[1].freq
    assert_equal 0.467, item.consensus.round(3) #fleiss kappa taking into account the weight
    assert_equal 0.363, item.consensus("entropy").round(3)



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
