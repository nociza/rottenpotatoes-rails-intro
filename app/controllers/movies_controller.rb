class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if session[:ratings] != nil
      @ratings_to_show = session[:ratings]
    else
      @ratings_to_show = []
    end 
    @all_ratings = Movie.all_ratings
    if params[:sort_by_title] != nil
      session[:sort_by_title] = 1
      session[:sort_by_date] = nil
      if params[:ratings] == nil
        @movies = Movie.names_sort
      else
        @movies = Movie.names_sort_filtered(params[:ratings])
        @ratings_to_show = params[:ratings]
        session[:ratings] = params[:ratings]
      end
    elsif params[:sort_by_date] != nil
      session[:sort_by_title] = nil
      session[:sort_by_date] = 1
      if params[:ratings] == nil
        @movies = Movie.dates_sort
      else
        @movies = Movie.dates_sort_filtered(params[:ratings])
        @ratings_to_show = params[:ratings]
        session[:ratings] = params[:ratings]
      end
    elsif params[:ratings] == nil
      if session[:ratings] != nil
        if session[:sort_by_title] != nil
          @movies = Movie.names_sort_filtered(session[:ratings])
        elsif session[:sort_by_date] != nil
          @movies = Movie.dates_sort_filtered(session[:ratings])
        else
          @movies = Movie.with_ratings(session[:ratings])
        end
      else 
        @movies = Movie.all
      end 
    else
      @movies = Movie.with_ratings(params[:ratings].keys)
      @ratings_to_show = params[:ratings].keys
      session[:ratings] = params[:ratings].keys
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
