class MoviesController < ApplicationController

	def index
		@test = Time.now
		@movie = MovieAPI.new
		@movieList = @movie.movieList

	end

	def searchMovies
		@test = Time.now
		if params[:page]
			@movie = MovieAPI.new(params[:page].to_i)
			@movieList = @movie.movieList
		end

		respond_to do |format|
			format.html
			format.js
		end
	end

end
