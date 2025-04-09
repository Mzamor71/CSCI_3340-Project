# Scenario: Searching for a movie
Given("I am on the homepage") do
  visit root_path
end

When("I search for {string}") do |search_term|
  fill_in "search", with: search_term
  click_button "Search"
end

Then("I should see {string} in the search results") do |movie_title|
  within(".search-results") do
    expect(page).to have_content(movie_title)
  end
end

Then("I should be able to click on the movie to view its details") do
  movie_title = page.find(".search-results").text.split("\n").first
  click_link movie_title
  expect(current_path).to match(/\/movies\/\d+/)
end

# Scenario: Filtering movies by genre
When("I select the {string} genre") do |genre_name|
  # Create the genre if it doesn't exist
  genre = Genre.find_by(name: genre_name) || Genre.create!(name: genre_name)
  # One way to use the genre variable would be to verify it was created successfully
  expect(genre).to be_persisted
  # Then proceed with UI interaction
  select genre_name, from: "genre"
  # After selecting, there may be a submit button to click
  click_button "Filter" if page.has_button?("Filter")
end

Then("I should see a list of movies that belong to the {string} genre") do |genre_name|
  # Create test data for this genre if none exists
  if Movie.joins(:genres).where(genres: { name: genre_name }).count == 0
    genre = Genre.find_by(name: genre_name)
    movie = Movie.create!(
      title: "Test #{genre_name} Movie",
      description: "A test movie for #{genre_name}",
      director: "Test Director",
      release_year: 2023
    )
    movie.genres << genre
  end

  # Verify that the results contain only movies of the selected genre
  within(".movie-list") do
    all(".movie-title").each do |movie_title|
      title = movie_title.text
      movie = Movie.find_by(title: title)
      expect(movie.genres.map(&:name)).to include(genre_name)
    end
  end
end