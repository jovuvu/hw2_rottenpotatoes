class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.uniq.pluck(:rating)
    
    session[:ratings] = @all_ratings unless (params["commit"] == "Refresh" && (session[:ratings] = params["ratings"].keys rescue nil))
    session[:Sort] = params["Sort"] unless (params["Sort"] == nil)
      

    query = {}
    query[:conditions] = ["rating IN (?)", session[:ratings]] unless (session[:ratings] == nil)
    query[:order] = "#{session[:Sort]} ASC" unless (session[:Sort] == nil)
    @movies = Movie.find(:all, query)
      
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
