class RatingsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @movie = Movie.find(params[:movie_id])
    @rating = Rating.new
  end

  def create
    @movie = Movie.find(params[:movie_id])
    @rating = @movie.ratings.new(rating_params)
    @rating.user = current_user

    if @rating.save
      redirect_to movie_path(@movie), notice: 'Rating was successfully created.'
    else
      render :new
    end
  end

  def show
    @rating = Rating.find(params[:id])
    @comments = @rating.comments.includes(:user)
    @comment = Comment.new
  end

  private
  
  def rating_params
    params.require(:rating).permit(:score, :comment)
  end
end
