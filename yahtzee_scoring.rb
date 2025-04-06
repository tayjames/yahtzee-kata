class YahtzeeScoring
  LARGE_STRAIGHTS = [[1, 2, 3, 4, 5], [2, 3, 4, 5, 6]].freeze
  SMALL_STRAIGHTS = [[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]].freeze
  FULL_HOUSE_EXCEPTIONS = [[4, 4, 6, 6, 6], [5, 5, 5, 6, 6], [5, 5, 6, 6, 6]].freeze

  def initialize(roll)
    @roll = roll
  end

  def best_score
    validate_roll
    score_lower_section
  end

  private

  def validate_roll
    raise "Invalid roll" if @roll.any? { |i| !i.between?(1, 6) } || @roll.count != 5
  end

  def score_lower_section
    [
      score_yahtzee,
      score_straights,
      score_full_house,
      score_oaks,
      score_chance
    ].compact.max_by { |result| result[:score] }
  end

  def score_yahtzee
    return { category: :yahtzee, score: 50 } if @roll.uniq.length == 1
  end

  def score_straights
    sorted_roll = @roll.uniq.sort

    return { category: :large_straight, score: 40 } if LARGE_STRAIGHTS.include?(sorted_roll)
    return { category: :small_straight, score: 30 } if SMALL_STRAIGHTS.any? { |s| (s - sorted_roll).empty? }
  end

  def score_full_house
    if @roll.tally.values.sort == [2, 3] && FULL_HOUSE_EXCEPTIONS.none? { |exception| exception == @roll.sort }
      return { category: :full_house, score: 25 }
    end
  end

  def score_oaks
    tally = @roll.tally.values

    return { category: :four_of_a_kind, score: @roll.sum } if tally.include?(4)
    return { category: :three_of_a_kind, score: @roll.sum } if tally.include?(3)
  end

  def score_chance
    { category: :chance, score: @roll.sum }
  end
end
