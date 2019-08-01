class Review < ApplicationRecord

	has_many :reviewGenres
	has_many :genres, through: :reviewGenres
	belongs_to :movie

	SEARCH_RESULTS = 6


	def getReviews(moviedbid, numberOfRecords = 0)

		if numberOfRecords > 0
			reviews = Review.where(moviedbid: moviedbid).order(date: :desc).limit(numberOfRecords)
		else
			reviews = Review.where(moviedbid: moviedbid).order(date: :desc)
		end
		reviewArray = []

		reviews.each do |r|
			individualReview = []
			individualReview.push(r.score.to_i)
			individualReview.push(r.comment)
			individualReview.push(User.find(r.user_id).email)
			individualReview.push(r.date.to_s)
			reviewArray.push(individualReview)
		end
		reviewArray
	end

	def getGenres(buttonStatus, sort)
		sortDirection = :desc
		if buttonStatus[2] == "active"
			sort == "asc" ? (sortDirection = :asc) : (sortDirection = :desc)
			genres = Genre.where(moviedbid: self.moviedbid).order(name: sortDirection)
		else
			genres = Genre.where(moviedbid: self.moviedbid).order(name: :asc)
		end

		genres
	end

	def getDates(reviews, dateBegin, dateEnd, noSearch)

		if dateBegin != "" && dateEnd != ""
				dateB = Date.parse(dateBegin)		
				dateE = Date.parse(dateEnd)
				movieIDs = Movie.where(["releasedate >= ? and releasedate <= ?", dateB, dateE]).pluck(:moviedbid)
		elsif dateBegin != ""
				date = Date.parse(dateBegin)		
				movieIDs = Movie.where("releasedate >= ?", date).pluck(:moviedbid)
		elsif dateEnd != ""		
				date = Date.parse(dateEnd)		
				movieIDs = Movie.where("releasedate <= ?", date).pluck(:moviedbid)
		end		
	
		if !noSearch
			reviews = reviews.where(moviedbid: movieIDs)
		else
			reviews = Review.where(moviedbid: movieIDs)
		end

		reviews
	end


	def reviewSearch(offset, title = "", score = 0, dateBegin = "", dateEnd = "", genre = "", sort = "desc", sortField = [])

		reviews = Review.new
		noSearch = true
		
		#title search
		if title != ""
			movieIDs = []
			movie = Movie.where(Movie.arel_table[:title].lower.matches("%#{title}%".downcase))
			movie.each do |m|
				movieIDs.push(m.moviedbid)
			end
			reviews = Review.where(moviedbid: movieIDs)
			noSearch = false
		end

		#score search
		if score > 0
			if !noSearch
				reviews = reviews.where("score = ?", score)
			else
				reviews = Review.where("score = ?", score)
				noSearch = false
			end
		end

		#date search
		if dateBegin != "" || dateEnd != ""
			if !noSearch
				reviews = self.getDates(reviews, dateBegin, dateEnd, noSearch)
			else
				reviews = self.getDates(nil, dateBegin, dateEnd, noSearch)
				noSearch = false
			end
		end

		#genre search
		if genre != ""
			movieIDs = []
			genre = Genre.where(Genre.arel_table[:name].lower.matches("%#{genre}%".downcase))
			genre.each do |g|
				movieIDs.push(g.moviedbid)
			end
			
			if !noSearch
				reviews = reviews.where(moviedbid: movieIDs)
			else
				reviews = Review.where(moviedbid: movieIDs)
				noSearch = false
			end
		end
		
		if noSearch 
			reviews = Review.all
		end			
		
		reviews = self.sortReviews(reviews, sortField, sort, offset)

		reviews

	end

	def sortReviews(reviews, sortField, sort, offset)
		sortDirection = :desc
		sort == "asc" ? (sortDirection = :asc) : (sortDirection = :desc)
		
		sortField.include?("active") ? (sortFieldIndex = sortField.index("active")) : (sortFieldIndex = 3)
		
		#[Title, Score, Genre, ReleaseDate, no search]
		if reviews.count > 0
			case sortFieldIndex
				when 0
					reviews = self.sortByMovieTitle(reviews, sort, offset)
				when 1
					reviews = reviews.order(score: sortDirection).limit(SEARCH_RESULTS).offset(SEARCH_RESULTS * offset)				
				when 2
					reviews = self.sortByGenre(reviews, sort, offset)
				when 3
					reviews = self.sortByReleaseDate(reviews, sort, offset)
			end
		end
		reviews
	end

	def sortByReleaseDate(reviews, sort, offset)
		sortDirection = :desc
		sort == "asc" ? (sortDirection = :asc) : (sortDirection = :desc)
		
		#get the movie release dates coupled with the review id 
		movieReviews = []
		reviews.each do |r|
			movieReviews.push([r.id, Movie.find_by(moviedbid: r.moviedbid).releasedate])
		end
		
		#sort by release date
		movieReviews.sort_by!{|x,y| y}
		sort == "asc" ? (nil) : (movieReviews.reverse!)

		#get review ids ordered by release date
		reviewIDs = []
		movieReviews.each do |m|
			reviewIDs.push(m[0])
		end

		finalSortedReviews = []

		#set the upper and lower bound of the review results. Only a certain number will be viewable at a time
		if (offset * SEARCH_RESULTS) >= reviewIDs.length 
			finalSortedReviews = []
			emtpyResults = true
		else
			lowerOffset = offset * SEARCH_RESULTS
		end

		upperOffset = self.getUpperOffset(offset, reviewIDs.length)
		
		emtpyResults ? (nil) :(finalSortedReviews = Review.find(reviewIDs[lowerOffset..upperOffset]))
		
		finalSortedReviews

	end

	def sortByMovieTitle(reviews, sort, offset)
		sortDirection = :desc
		sort == "asc" ? (sortDirection = :asc) : (sortDirection = :desc)

		#get the movie titles coupled with the review id
		movieReviews = []
		reviews.each do |r|
			movieReviews.push([r.id, Movie.find_by(moviedbid: r.moviedbid).title])
		end
		
		#sort by movie title
		movieReviews.sort_by!{|x,y| y}
		sort == "asc" ? (nil) : (movieReviews.reverse!)

		#get review ids ordered by movie title
		reviewIDs = []
		movieReviews.each do |m|
			reviewIDs.push(m[0])
		end

		finalSortedReviews = []

		#set the upper and lower bound of the review results. Only a certain number will be viewable at a time
		if (offset * SEARCH_RESULTS) >= reviewIDs.length 
			finalSortedReviews = []
			emtpyResults = true
		else
			lowerOffset = offset * SEARCH_RESULTS
		end

		upperOffset = self.getUpperOffset(offset, reviewIDs.length)

		emtpyResults ? (nil) :(finalSortedReviews = Review.find(reviewIDs[lowerOffset..upperOffset]))
		

		finalSortedReviews

	end

	def sortByGenre(reviews, sort, offset)

		#get review ids
		reviewIDs = []
		reviews.each do |r|
			reviewIDs.push(r.id)
		end

		#check the join table between reviews and genres and get the matching genre ids
		revGen = ReviewGenre.where(review_id: reviewIDs)		

		revGenNames = []

		#get the genre names coupled with the review id
		revGen.each do |r|
			revGenNames.push([r.review_id, Genre.find(r.genre_id).name])
		end

		#sort by genre name
		revGenNames.sort_by!{|x,y|y}
		sort == "asc" ? (nil) : (revGenNames.reverse!)

		#get review ids ordered by genre name
		sortedRevIDs = []
		revGenNames.each do |r|
			sortedRevIDs.push(r[0])
		end

		#set the upper and lower bound of the review results. Only a certain number will be viewable at a time
		sortedRevIDs.uniq!
		emtpyResults = false
		 if (offset * SEARCH_RESULTS) >= sortedRevIDs.length 
			finalSortedReviews = []
			emtpyResults = true
		else
			lowerOffset = offset * SEARCH_RESULTS
		end
		
		upperOffset = self.getUpperOffset(offset, sortedRevIDs.length)
		
		emtpyResults ? (nil) :(finalSortedReviews = Review.find(sortedRevIDs[lowerOffset..upperOffset]))
		
		finalSortedReviews

	end

	def getUpperOffset(offset, sortedIDLength)

		(((offset + 1) * SEARCH_RESULTS) - 1) >= sortedIDLength ? (upperOffset = (sortedIDLength - 1)) : (upperOffset = ((offset + 1) * SEARCH_RESULTS) - 1)
		upperOffset

	end

	def avgScore(moviedbid)

		reviews = Review.where(moviedbid: moviedbid)
		count = reviews.count
		sum = 0
		avg = 0
		reviews.each do |r|
			sum += r.score.to_i
		end

		count == 0 ? (nil) : (avg = (sum.to_f/count).round)

		avg
		
	end

	def userReviewIDs(moviedbid)
		reviews = Review.where(moviedbid: moviedbid)
		ids = []
		reviews.each do |r|
			ids.push(r.user_id)
		end
		ids
	end

end
