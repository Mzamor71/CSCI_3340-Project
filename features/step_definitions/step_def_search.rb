
# Scenario: Searching for a movie
Given("I am on the homepage") do
  # Create genres before loading the page to ensure they're available
  unless Genre.exists?(name: "Science Fiction")
    Genre.create!(name: "Science Fiction")
  end
  visit root_path
end

When("I search for {string}") do |search_term|
  # Create a test movie with the search term if it doesn't exist
  unless Movie.exists?(title: search_term)
    Movie.create!(
      title: search_term,
      description: "A test movie for #{search_term}",
      director: "Test Director",
      release_year: 2020
    )
  end
  
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
  # Get the genre (it should already exist from the Given step)
  genre = Genre.find_by(name: genre_name)
  expect(genre).to be_present, "Genre '#{genre_name}' was not found in the database"
  
  # Create a test movie for this genre if none exists
  if genre.movies.count == 0
    movie = Movie.create!(
      title: "Test #{genre_name} Movie",
      description: "A test movie for #{genre_name}",
      director: "Test Director",
      release_year: 2023
    )
    movie.genres << genre
    movie.save!
  end
  
  # Reload the page to ensure the genre is in the dropdown
  visit current_path
  
  # Then proceed with UI interaction
  select genre_name, from: "genre"
  click_button "Filter"
end

Then("I should see a list of movies that belong to the {string} genre") do |genre_name|
  # Verify that the results contain only movies of the selected genre
  within(".search-results") do
    expect(page).to have_content("Test #{genre_name} Movie")
    
    all(".movie-title").each do |movie_element|
      title = movie_element.text
      movie = Movie.find_by(title: title)
      expect(movie.genres.map(&:name)).to include(genre_name)
    end
  end
end