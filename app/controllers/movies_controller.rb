class MoviesController < ApplicationController

	def index
		@movie = MovieAPI.new
		@movieList = @movie.movieList
		@categoryHide = "display: none"

	end

	def searchMovies

		if params[:search] == ""
			@categoryHide = "display: none"
		else
			@categoryHide = ""
		end

		@movie = MovieAPI.new(params[:page].to_i, params[:search])
		@movie.setCategory(params[:category])
		@movieList = @movie.movieList

		# if params[:search] == ""
		# 	@movie = MovieAPI.new
		# 	@movie.search = params[:search]
		# 	@movieList = @movie.movieList
		# 	@categoryHide = ""
		# else
		# 	@categoryHide = "display: none"
		# end

		# if params[:category]
		# 	@movie = MovieAPI.new(params[:page].to_i)
		# 	@movie.setCategory(params[:category])
		# 	@movieList = @movie.movieList
		# elsif params[:page]
		# 	@movie = MovieAPI.new(params[:page].to_i)
		# 	@movieList = @movie.movieList
		# end

		respond_to do |format|
			format.html
			format.js
		end
	end

end
