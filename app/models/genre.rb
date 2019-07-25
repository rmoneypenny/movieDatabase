class Genre < ApplicationRecord

	has_many :reviewGenres
	has_many :reviews, through: :reviewGenres

end
