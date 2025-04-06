require "minitest/autorun"
require_relative "yahtzee_scoring"

class TestYahtzeeScoring < Minitest::Test
  def test_best_score
    assert_equal({ category: :yahtzee, score: 50 }, YahtzeeScoring.new([6, 6, 6, 6, 6]).best_score)
    assert_equal({ category: :large_straight, score: 40 }, YahtzeeScoring.new([2, 3, 4, 5, 6]).best_score) # tests that large straight is preferred over small straight
    assert_equal({ category: :three_of_a_kind, score: 21 }, YahtzeeScoring.new([6, 6, 6, 2, 1]).best_score)
    assert_equal({ category: :full_house, score: 25 }, YahtzeeScoring.new([3, 3, 3, 5, 5]).best_score)
    assert_equal({ category: :chance, score: 17 }, YahtzeeScoring.new([1, 2, 3, 5, 6]).best_score)
  end

  def test_invalid_roll
    assert_raises(RuntimeError) { YahtzeeScoring.new([1, 2, 3, 4]).best_score } # too short
    assert_raises(RuntimeError) { YahtzeeScoring.new([1, 2, 3, 4, 5, 6]).best_score } # too long
    assert_raises(RuntimeError) { YahtzeeScoring.new([1, 2, 3, 4, 7]).best_score } # too high
    assert_raises(RuntimeError) { YahtzeeScoring.new([0, 2, 3, 4, 5]).best_score } # too low
    assert_raises(RuntimeError) { YahtzeeScoring.new([0, 2, 3, 4, "e"]).best_score } # non-numeric
  end

  def test_small_straight
    assert_equal({ category: :small_straight, score: 30 }, YahtzeeScoring.new([1, 2, 3, 4, 4]).best_score) 
    assert_equal({ category: :small_straight, score: 30 }, YahtzeeScoring.new([1, 2, 3, 4, 6]).best_score) # tests rolls like such aren't categorized as 'chance'
  end

  def test_four_of_a_kind
    assert_equal({ category: :four_of_a_kind, score: 24 }, YahtzeeScoring.new([5, 5, 5, 5, 4]).best_score)
  end

  def test_full_house_exceptions
    assert_equal({ category: :three_of_a_kind, score: 26 }, YahtzeeScoring.new([4, 4, 6, 6, 6]).best_score)
    assert_equal({ category: :three_of_a_kind, score: 27 }, YahtzeeScoring.new([5, 5, 5, 6, 6]).best_score)
    assert_equal({ category: :three_of_a_kind, score: 28 }, YahtzeeScoring.new([5, 5, 6, 6, 6]).best_score)
  end
end
