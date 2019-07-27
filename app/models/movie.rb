class Movie < ApplicationRecord

	validates :moviedbid, presence: true , uniqueness: true
	has_many :reviews

end
