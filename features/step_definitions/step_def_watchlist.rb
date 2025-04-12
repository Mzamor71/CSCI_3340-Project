# features/step_definitions/watchlist_steps.rb

# Scenario: Adding a movie to the watchlist
When("I click the {string} button in watchlist") do |button_text|
  click_on(button_text)
end

Then("the movie should be added to my watchlist") do
  # Get the current user and movie
  current_user = User.find_by(username: page.find(".user-info").text)
  movie_title = page.find(".movie-title").text
  movie = Movie.find_by(title: movie_title)
  
  # Check if the movie is in the user's watchlist
  expect(current_user.watchlist_items.where(movie: movie)).to exist
  
  # Check for UI confirmation
  expect(page).to have_content("Movie added to your watchlist") || 
                  have_content("In your watchlist") ||
                  have_button("Remove from Watchlist")
end

# Scenario: Removing a movie from the watchlist
Given("I have {string} in my watchlist") do |movie_title|
  # First make sure the user is logged in
  steps %Q{
    Given I am logged in as "user1"
  }

  # Find or create the movie
  movie = Movie.find_by(title: movie_title) || Movie.create!(title: movie_title, director: "Test Director", release_year: 2020, description: "A movie for testing")
  
  # Find the current user (assumed to be logged in from previous step)
  current_user = User.find_by(username: "user1")
  
  # Add the movie to the user's watchlist if it's not already there
  unless WatchlistItem.find_by(user: current_user, movie: movie)
    WatchlistItem.create!(user: current_user, movie: movie)
  end
  
  # Visit the movie page
  visit movie_path(movie)
  
  # Verify the movie is in the watchlist (UI check)
  expect(page).to have_button("Remove from Watchlist")
end

Then("the movie should be removed from my watchlist") do
  # Get the current user and movie
  current_user = User.find_by(username: page.find(".user-info").text)
  movie_title = page.find(".movie-title").text
  movie = Movie.find_by(title: movie_title)
  
  # Check that the movie is not in the user's watchlist
  expect(current_user.watchlist_items.where(movie: movie)).not_to exist
  
  # Check for UI confirmation
  expect(page).to have_content("Movie removed from your watchlist") || 
                  have_content("In your watchlist")
                  have_button("Add to Watchlist")
end