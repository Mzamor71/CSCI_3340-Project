class SearchController < ApplicationController
  def index
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      # Search by title OR by genre name
      @movies = Movie.left_joins(:genres)
                    .where("lower(movies.title) LIKE ? OR lower(genres.name) LIKE ?", 
                           search_term, search_term)
                    .distinct
    elsif params[:genre].present?
      genre = Genre.find(params[:genre])
      @movies = genre.movies
    else
      @movies = Movie.all
    end
  end
end