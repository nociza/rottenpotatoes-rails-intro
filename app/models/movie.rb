class Movie < ActiveRecord::Base
  def self.all_ratings
    ['G','PG','PG-13','R']
  end 
  
  def self.with_ratings(ratings)
    Movie.where(rating: ratings)
  end
end
