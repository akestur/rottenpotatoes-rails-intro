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
    if (params[:sort_order])
      flash[:notice] = params[:sort_order].class
      @sort_type = params[:sort_order]
      if @sort_type == "title"
        @movies = Movie.order(title: :asc)
      end
      if @sort_type == "release_date"
          @movies = Movie.order(release_date: :asc)
      end
    end
    @movies = Movie.all
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


  def title_sorter
    @movies = Movie.order(title: :asc)
    # Movie.delete_all
    # flash[:notice] = @movies
    @movies.each do |movie|
      @movie_del = Movie.find(movie['id'])
      @movie_del.destroy
      Movie.create!(:title => movie['title'], :rating => movie['rating'], :description => movie['description'], :release_date => movie['release_date'])
    end
    redirect_to movies_path
  end
  #
  # def release_date_sorter
  #   @movies = Movie.order(release_date: :asc)
  #   # Movie.delete_all
  #   # flash[:notice] = @movies
  #   @movies.each do |movie|
  #     @movie_del = Movie.find(movie['id'])
  #     @movie_del.destroy
  #     Movie.create!(:title => movie['title'], :rating => movie['rating'], :description => movie['description'], :release_date => movie['release_date'])
  #   end
  #   redirect_to movies_path
  # end

end
