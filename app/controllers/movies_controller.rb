class MoviesController < ApplicationController

	def index
		@movie = MovieAPI.new
		@movieList = @movie.movieList
		@categoryHide = "display: none"

	end

	def searchMovies

		@movie = MovieAPI.new(params[:page].to_i, params[:search])
		@movieList = @movie.movieList

		respond_to do |format|
			format.html
			format.js
		end
	end

end
