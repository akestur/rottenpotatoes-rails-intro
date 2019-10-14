class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies =  Movie.all
    @all_ratings = ['G','PG','PG-13','R']
    @title_toggle = "p-3 mb-2 bg-warning text-dark"
    @date_toggle = "p-3 mb-2 bg-warning text-dark"

    if params[:ratings].blank?
      if !session[:ratings].blank?
        params[:ratings] = session[:ratings]
      end
    end

    if params[:sort_order].blank?
      if !session[:sort_order].blank?
        params[:sort_order] = session[:sort_order]
      end
    end


    if (params[:ratings].length > 0)
      session[:ratings] = params[:ratings]
      @curr_ratings = []
      @ratings_hash = params[:ratings]
      if @ratings_hash["G"]
        @curr_ratings << "G"
      end
      if @ratings_hash["PG"]
        @curr_ratings << "PG"
      end
      if @ratings_hash["PG-13"]
        @curr_ratings << "PG-13"
      end
      if @ratings_hash["R"]
        @curr_ratings << "R"
      end
      @movies = Movie.where(rating: @curr_ratings)
      flash[:notice] = "filtered"
    end
    if !(params[:ratings]) || params[:ratings].length == 0
      @movies = Movie.where(rating: @all_ratings)
      flash[:notice] = "all"
    end
    if (params[:sort_order])
      session[:sort_order] = params[:sort_order]
      @sort_type = params[:sort_order]
      if @sort_type == "title"
        @title_toggle = "hilite"
        @date_toggle = "p-3 mb-2 bg-warning text-dark"
        @movies = Movie.order(title: :asc)
      end
      if @sort_type == "release_date"
        @title_toggle = "p-3 mb-2 bg-warning text-dark"
        @date_toggle = "hilite"
        @movies = Movie.order(release_date: :asc)
      end
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

end
