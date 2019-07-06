class PagesController < ApplicationController

	def show
		movie = MovieAPI.new
		movie.movieList(1)
	end

end
