class Review < ApplicationRecord

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
		puts reviewArray
		reviewArray

	end

	def reviewSearch(offset, title = "", score = 0, dateBegin = "", dateEnd = "", genre = "", sort = "desc", sortField = [])

		#Review.order(date: :desc).limit(5).offset(5 * offset)
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
		if dateBegin != ""
			if !noSearch
				date = Date.parse(dateBegin)
				reviews = reviews.where("date >= ?", date)
			else
				date = Date.parse(dateBegin)
				reviews = Review.where("date >= ?", date)
				noSearch = false
			end			
		end
		if dateEnd != ""
			if !noSearch
				date = Date.parse(dateEnd)
				reviews = reviews.where("date <= ?", date)
			else
				date = Date.parse(dateEnd)
				reviews = Review.where("date <= ?", date)
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

		sortDirection = :desc
		sort == "asc" ? (sortDirection = :asc) : (sortDirection = :desc)
		#[Title, Score, Genre, ReleaseDate]
		sortFieldIndex = sortField.index("active")
		#if no search parameters are used
		if noSearch	
				reviews = Review.order(date: sortDirection).limit(5).offset(5 * offset)
		else
				reviews = reviews.order(date: sortDirection).limit(5).offset(5 * offset)
		end
		reviews

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
