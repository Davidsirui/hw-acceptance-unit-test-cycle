class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    
    @all_ratings = Movie.all_ratings

    sort = params[:sort] || session[:sort]
    @ordering = session[:sort]
    
    # if sort == 'title'
    #   @title_cls = 'hilite'
    # elsif sort == 'release_date'
    #   @release_cls = 'hilite'
    # end
    
    set_rate_to_show()
                      
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
      flash.keep
    else
        if !session[:sort].nil?
          flash.keep
          redirect_to sort => sort, ratings: @ratings_to_show
        else
          flash.keep
          redirect_to ratings: @ratings_to_show
        end
    end
    
       
    @movies = Movie.with_ratings(@ratings_to_show.keys).order(@ordering)
    
    session[:sort] = sort
    session[:ratings] = @ratings_to_show
  end
  
  def set_rate_to_show
    @ratings_to_show = params[:ratings] || session[:ratings] \
      || Hash[@all_ratings.map { |r| [r, 1] }]
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
  
  def search_directors
    @movie = Movie.find(params[:id])
    director = @movie.director

    # if director and !director.empty?
    if !director.nil? and !director.blank?
      @movies = Movie.search_similar_movies @movie.director
      render 'similar_movies'
    else
      flash[:notice] = "'#{@movie.title}' has no director info"
      redirect_to movies_path
    end
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
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end
end
