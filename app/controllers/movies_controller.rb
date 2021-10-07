class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      
      @movies = Movie.all
      
      if request.path == '/' #For a default path
        reset_session
      end
      
      @ratings_to_show =!session[:ratings_to_show].nil? ? session[:ratings_to_show]:[]
      if !session[:sort_by].nil?
        
        # here we check the session sort and parameter sort
        if !params[:sort].nil? and params[:sort] != session[:sort_by] 
          session[:sort_by] = params[:sort]
        end
        @sort = session[:sort_by]
      else
        
        # we prioritize session sort
        @sort = params[:sort] 
      end
      
      #==save current sort==
      session[:sort_by] = @sort 
      
      if !params[:ratings].nil?
        #==save current ratings_to_show==
        @ratings_to_show = params[:ratings].keys
        session[:ratings_to_show] = @ratings_to_show
      end
      
      @movies = Movie.with_ratings(@ratings_to_show)
      @all_ratings = Movie.all_ratings      
      
      # this finalize the hw2
      
      # if request.path == '/' #For a default path
      #   reset_session
      # end
      
      
      # @ratings_to_show = []
      # # if !session[:ratings_to_show].nil?
      # #   @ratings_to_show = session[:ratings_to_show]
      # # end  
      # # @ratings_to_show =!session[:ratings_to_show].nil? ? session[:ratings_to_show]:[]
      # if !params[:ratings].nil?
      #   @ratings_to_show = params[:ratings].keys
      #   session[:ratings_to_show] = @ratings_to_show
      # else
      #   if !session[:ratings_to_show].nil?
      #     @ratings_to_show = session[:ratings_to_show]
      #   end
      # end
      
      # @all_ratings = Movie.all_ratings
      # # @ratings_to_show = params[:ratings].keys
      
      
      # @movies = Movie.with_ratings(@ratings_to_show)
      
      
      # # get all the movies
      # # @movies = Movie.all
      
      # if !params[:sort].nil?
      #   @sort = params[:sort]
      #   session[:sort_by] = @sort
      # else
        
        
      # if session[:sort_by].nil?
      #   @sort = params[:sort]
      # else
      #   if !params[:sort].nil? and params[:sort] != session[:sort_by] #What if the sort value is changed?
      #     session[:sort_by] = params[:sort]
      #   end
      #   @sort = session[:sort_by]
      # end

      # @sort = params[:sort]     # get the sort argument from index.html
      @movies = @movies.order(@sort)
      
      
      
      if((@sort <=> "title") == 0)
        @title_klass = 'bg-success'
      else
        @title_klass = 'hilite'
      end
      
      if((@sort <=> "release_date") == 0)
        @release_date_klass = 'bg-success'
      else
        @release_date_klass = 'hilite'
      end
      
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end