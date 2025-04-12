class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments or /comments.json
def index
  if params[:movie_id]
    @movie = Movie.find(params[:movie_id])
    @comments = Comment.joins(rating: :movie).where(ratings: { movie_id: params[:movie_id] })
  else
    @comments = Comment.all
  end
end

  # GET /comments/1 or /comments/1.json
  def show
    @movie = @comment.rating.movie
  end

  # GET /comments/new
  def new 
    @comment = Comment.new(rating_id: params[:rating_id], user_id: current_user.id)
    
    # If coming from a movie's comments page, get the movie for navigation
    @movie = Movie.find(params[:movie_id]) if params[:movie_id]
    
    # If we have a rating_id but no movie yet, try to get the movie through the rating
    if @movie.nil? && params[:rating_id].present?
      rating = Rating.find_by(id: params[:rating_id])
      @movie = rating.movie if rating
    end
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params)
    @movie = @comment.rating.movie
  
    respond_to do |format|
      if @comment.save
        format.html { redirect_to movie_comments_path(@movie), notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    # Store movie reference before destroying the comment
    movie = @comment.rating.movie
    @comment.destroy!
  
    respond_to do |format|
      format.html { 
        redirect_to movie_comments_path(movie), 
        status: :see_other, 
        notice: "Comment was successfully destroyed." 
      }
      format.json { head :no_content }
    end
  end

  def like
    @comment = Comment.find(params[:id])
    @comment.increment!(:likes_count)
    redirect_back(fallback_location: root_path, notice: "Comment liked successfully.")
  end
  
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params.require(:id))
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit ([:user_id, :rating_id, :content, :likes_count])
    end

   
end
