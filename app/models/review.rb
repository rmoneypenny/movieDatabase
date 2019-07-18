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
			reviewArray.push(individualReview)
		end
		puts reviewArray
		reviewArray

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
