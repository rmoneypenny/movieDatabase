class PagesController < ApplicationController

	def show
		@movie = Movie.order(releasedate: :desc).limit(10)
		@review = Review.new
		@genres = Genre.new
		@recentReviews = Review.order(updated_at: :desc).limit(3)
	end

	def about

	end

end
