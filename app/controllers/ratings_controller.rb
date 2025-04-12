class RatingsController < ApplicationController
  before_action :set_rating, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /ratings or /ratings.json
  def index
    @ratings = Rating.all
  end

  # GET /ratings/1 or /ratings/1.json
  def show
    @comment = Comment.new(rating: @rating)
  end

  # GET /ratings/new
  def new
    @movie = Movie.find(params[:movie_id]) if params[:movie_id]
    @rating = Rating.new(movie: @movie)
  end

  # GET /ratings/1/edit
  def edit
  end

  # POST /ratings or /ratings.json
  def create
    @rating = Rating.new(rating_params)
    @rating.user = current_user unless @rating.user_id

    respond_to do |format|
      if @rating.save
        format.html { redirect_to movie_path(@rating.movie), notice: "Rating was successfully created." }
        format.json { render :show, status: :created, location: @rating }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ratings/1 or /ratings/1.json
  def update
    respond_to do |format|
      if @rating.update(rating_params)
        format.html { redirect_to movie_path(@rating.movie), notice: "Rating was successfully updated." }
        format.json { render :show, status: :ok, location: @rating }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ratings/1 or /ratings/1.json
  def destroy
    movie = @rating.movie
    @rating.destroy!

    respond_to do |format|
      format.html { redirect_to movie_path(movie), notice: "Rating was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rating_params
      params.require(:rating).permit(:user_id, :movie_id, :stars)
    end
end