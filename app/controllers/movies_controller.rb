class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      
      # get all the movies
      @movies = Movie.all
      @sort = params[:sort]     # get the sort argument from index.html
      @movies = @movies.order(@sort)
      
      if((@sort <=> "title") == 0)
        @title_klass = 'bg-info'
      else
        @title_klass = 'hilite'
      end
      
      if((@sort <=> "release_date") == 0)
        @release_date_klass = 'bg-info'
      else
        @release_date_klass = 'hilite'
      end
      
      # if @sort
        
      #     case @sort    # check all the sort argument 
          
      #     when "title"
      #       @title_header = 'bg-success'    
            
      #     when !"title"
      #       @title_header = 'hilite' 
            
      #     when "release_date"
      #       @release_date_header = 'bg-success'
            
      #     when !"release_date"
      #       @release_date_header = 'hilite'
      #     end
          
      # end
      
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