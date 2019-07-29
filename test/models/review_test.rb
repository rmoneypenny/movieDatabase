require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  test "no reviews found" do
    review = Review.new
    results = review.getReviews(4, 0).count
    assert_equal(0, results)
  end

  test "reviews found" do
  	review = Review.new
  	results = review.getReviews(1, 5).count
  	assert_equal(2, results)
  end

  test "average score" do
  	review = Review.new
  	results =  review.avgScore(1)
  	assert_equal(1, results)
  end

end
