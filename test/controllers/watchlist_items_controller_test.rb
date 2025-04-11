require "test_helper"

class WatchlistItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @watchlist_item = watchlist_items(:one)
  end

  test "should get index" do
    get watchlist_items_url
    assert_response :success
  end

  test "should get new" do
    get new_watchlist_item_url
    assert_response :success
  end

  test "should create watchlist_item" do
    assert_difference("WatchlistItem.count") do
      post watchlist_items_url, params: { watchlist_item: { movie_id: @watchlist_item.movie_id, user_id: @watchlist_item.user_id } }
    end

    assert_redirected_to watchlist_item_url(WatchlistItem.last)
  end

  test "should show watchlist_item" do
    get watchlist_item_url(@watchlist_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_watchlist_item_url(@watchlist_item)
    assert_response :success
  end

  test "should update watchlist_item" do
    patch watchlist_item_url(@watchlist_item), params: { watchlist_item: { movie_id: @watchlist_item.movie_id, user_id: @watchlist_item.user_id } }
    assert_redirected_to watchlist_item_url(@watchlist_item)
  end

  test "should destroy watchlist_item" do
    assert_difference("WatchlistItem.count", -1) do
      delete watchlist_item_url(@watchlist_item)
    end

    assert_redirected_to watchlist_items_url
  end
end
