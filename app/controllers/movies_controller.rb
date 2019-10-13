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
    @movies = Movie.all
    @all_ratings = ['G','PG','PG-13','R']
    @title_toggle = "p-3 mb-2 bg-warning text-dark"
    @date_toggle = "p-3 mb-2 bg-warning text-dark"
    if (params[:sort_order])
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
    flash[:notice] = params
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
