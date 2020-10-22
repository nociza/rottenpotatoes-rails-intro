class Movie < ActiveRecord::Base
  def self.all_ratings
    ['G','PG','PG-13','R']
  end 
  
  def self.with_ratings(ratings)
    Movie.where(rating: ratings)
  end
  
  def self.names_sort
    Movie.order(:title)
  end 
  
  def self.dates_sort
    Movie.order(:release_date)
  end
  
  def self.names_sort_filtered(ratings)
    Movie.where(rating: ratings).order(:title)
  end
  
  def self.dates_sort_filtered(ratings)
    Movie.where(rating: ratings).order(:release_date)
  end
end
