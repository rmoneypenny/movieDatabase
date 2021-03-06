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

		review = Review.new(user_id: current_user.id, moviedbid: params[:moviedbid], comment: params[:comment], date: DateTime.now.to_date, score: params[:score])
		review.save
		genre = Genre.where(moviedbid: params[:moviedbid])
		movie = Movie.find_by(moviedbid: params[:moviedbid])
		review.genres << genre
		movie.reviews << review
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
		@buttonStatus = params[:buttonStatus] || ["", "", "", "active"]
		@title = params[:title] || ""
		@score = params[:score] || "0"
		@dateBegin = params[:dateBegin] || ""
		@dateEnd = params[:dateEnd] || ""
		@genre = params[:genre] || ""
		@sort = params[:sort] || [false, "desc"]
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

	def loggedInUserReviews
		@reviews = Review.where(user_id: current_user.id)
	end

	def edit
		@review = Review.find(params[:id])
		@movie = Movie.find_by(moviedbid: @review.moviedbid)
		if @review.user_id != current_user.id
			flash[:error] = "Review ID is associated with a different user"
			redirect_to root_path
		end
	end

	def update
		@review = Review.find(params[:id])
		if @review.user_id == current_user.id
			@review.update(score: params[:score], comment: params[:comment], date: DateTime.now.to_date)
			flash[:notice] = "Review updated!"
			redirect_to settings_editReviews_path
		else
			flash[:error] = "Review ID is associated with a different user"
			redirect_to root_path
		end
	end

	def destroy
		@review = Review.find(params[:id])
		@rg = ReviewGenre.where(review_id: @review.id)
		@movie = Movie.find_by(moviedbid: @review.moviedbid)
		if @review.user_id == current_user.id
			@rg.destroy_all
			@review.destroy
			if @movie.reviews.count == 0
				Genre.where(moviedbid: @movie.moviedbid).destroy_all
				@movie.destroy
			end
			#@movie.reviews.count == 0 ? (@movie.destroy) : (nil)
			flash[:notice] = "Review deleted!"
			redirect_to settings_editReviews_path
		else
			flash[:error] = "Review ID is associated with a different user"
			redirect_to root_path
		end		
	end

end

