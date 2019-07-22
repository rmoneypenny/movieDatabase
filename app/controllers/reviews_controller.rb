class ReviewsController < ApplicationController

	def create
		if !Movie.exists?(moviedbid: params[:moviedbid])
			movieAPI = MovieAPI.new
			movieInfo = movieAPI.getMovieInfo(params[:moviedbid])
			movieInfo[3].each do |m|
				Genre.create(moviedbid: params[:moviedbid], name: m)
			end
			movie = Movie.new(moviedbid: params[:moviedbid], title: movieInfo[1], releasedate: movieInfo[2], poster_path: movieInfo[4])
			movie.save
		end

		Review.create(user_id: current_user.id, moviedbid: params[:moviedbid], comment: params[:comment], date: DateTime.now.to_date, score: params[:score])
		redirect_to movies_path
	end

	def show
		@rev = Review.new
		@movie = Movie.find_by(moviedbid: params[:id])
		@reviews = Review.where(moviedbid: params[:id])
		@avgScore = @rev.avgScore(params[:id])
		@genres = Genre.where(moviedbid: params[:id])
	end

	def index
		@rev = Review.new
		@page = 0
		@buttonStatus = ["", "", "", "active"]
		@sort = [false, "desc"]
		@reviews = @rev.reviewSearch(@page)
	end

	def searchReviews
		@buttonStatus = params[:buttonStatus] || ["", "", "", ""]
		@title = params[:title] || ""
		@score = params[:score] || "0"
		@dateBegin = params[:dateBegin] || ""
		@dateEnd = params[:dateEnd] || ""
		@genre = params[:genre] || ""
		@sort = params[:sort] || [false, ""]
		@page = 0
		@rev = Review.new
		
		if @sort[0] == "true"
			@sort[1] == "asc" ? (@sort = [false, "desc"]) : (@sort = [false, "asc"])
		end
		#check to ensure page doesn't drop below 0
		if params[:page]
			params[:page].to_i > 0 ? (@page = params[:page].to_i) : (@page = 0)
		end
		@reviews = @rev.reviewSearch(@page, @title, @score.to_i, @dateBegin, @dateEnd, @genre, @sort[1], @buttonStatus)
		#check if page number goes beyond search results
		if @reviews.empty?
			@page -= 1
			@reviews = @rev.reviewSearch(@page, @title, @score.to_i, @dateBegin, @dateEnd, @genre, @sort[1], @buttonStatus)
		end
		

		respond_to do |format|
			format.html
			format.js
		end
	end

end

