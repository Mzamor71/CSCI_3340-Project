class SearchController < ApplicationController
  def index
    if params[:search].present?
      # Use case-insensitive LIKE instead of ILIKE for SQLite compatibility
      @movies = Movie.where("lower(title) LIKE ?", "%#{params[:search].downcase}%")
    elsif params[:genre].present?
      genre = Genre.find(params[:genre])
      @movies = genre.movies
    else
      @movies = Movie.all
    end
  end
end