class PagesController < ApplicationController

	def show
		@movie = Movie.order(releasedate: :desc).limit(10)
		@review = Review.new
		@genres = Genre.new
		@recentReviews = Review.order(date: :desc).limit(3)
	end

end
