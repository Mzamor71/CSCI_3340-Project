class WatchlistItemsController < ApplicationController
  before_action :set_watchlist_item, only: %i[ show edit update destroy ]

  # GET /watchlist_items or /watchlist_items.json
  def index
    @watchlist_items = WatchlistItem.all
  end

  # GET /watchlist_items/1 or /watchlist_items/1.json
  def show
  end

  # GET /watchlist_items/new
  def new
    @watchlist_item = WatchlistItem.new
  end

  # GET /watchlist_items/1/edit
  def edit
  end

  # POST /watchlist_items or /watchlist_items.json
  def create
    @watchlist_item = WatchlistItem.new(watchlist_item_params)

    respond_to do |format|
      if @watchlist_item.save
        format.html { redirect_to @watchlist_item, notice: "Watchlist item was successfully created." }
        format.json { render :show, status: :created, location: @watchlist_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @watchlist_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /watchlist_items/1 or /watchlist_items/1.json
  def update
    respond_to do |format|
      if @watchlist_item.update(watchlist_item_params)
        format.html { redirect_to @watchlist_item, notice: "Watchlist item was successfully updated." }
        format.json { render :show, status: :ok, location: @watchlist_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @watchlist_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /watchlist_items/1 or /watchlist_items/1.json
  def destroy
    @watchlist_item.destroy!

    respond_to do |format|
      format.html { redirect_to watchlist_items_path, status: :see_other, notice: "Watchlist item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_watchlist_item
      @watchlist_item = WatchlistItem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def watchlist_item_params
      params.expect(watchlist_item: [ :user_id, :movie_id ])
    end
end
