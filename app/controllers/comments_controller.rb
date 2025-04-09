class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @rating = Rating.find(params[:rating_id])
    @comment = @rating.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to rating_path(@rating), notice: "Comment posted!"
    else
      redirect_to rating_path(@rating), alert: "Comment failed to post."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
