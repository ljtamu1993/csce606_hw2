class Movie < ActiveRecord::Base
    
    def self.all_ratings
        return Movie.distinct.pluck(:rating).sort
    end
    
    def self.with_ratings(ratings_list)
        if ratings_list.empty?
            return Movie.all
        end
        return Movie.where(rating: ratings_list)
    end
    
    def self.sort(sort_key)
        return Movie.order(sort_key)
    end
    
end