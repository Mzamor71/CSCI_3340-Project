class ReviewsController < ApplicationController
  def new
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.new
  end
  
  def create
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.build(review_params)
    @review.user = current_user
  
    if @review.save
      redirect_to review_path(@review), notice: "Review created!"
    else
      render :new
    end
  end
  
end
