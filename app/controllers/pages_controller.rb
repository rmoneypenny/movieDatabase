class PagesController < ApplicationController

	def show
		movie = MovieAPI.new
		movie.movieList
	end

end
