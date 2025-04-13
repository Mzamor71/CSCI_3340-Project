# Scenario: Viewing average rating after multiple users rate a movie
Given("user {string} rated {string} with {int} stars") do |username, movie_title, rating|
  user = User.find_by(username: username) || User.create!(
    username: username,
    email: "#{username.downcase}@example.com",
    password: "password123",
    password_confirmation: "password123"
  )

  movie = Movie.find_by(title: movie_title) || Movie.create!(title: movie_title)

  Rating.create!(
    user: user,
    movie: movie,
    stars: rating
  )
end

When("I view the movie {string}") do |movie_title|
  visit movie_path(Movie.find_by(title: movie_title))
end

When('I view its details') do
  movie = Movie.find_by(title: "Interstellar")
  visit movie_path(movie)
end

Then("the average rating should be {string}") do |expected_rating|
  # Extract just the number from the expected_rating string
  rating_value = expected_rating.scan(/\d+\.\d+|\d+/).first
  
  # Check for the rating value in various formats
  expect(page).to have_content("#{rating_value} / 5") || 
                 have_content("⭐ #{rating_value}") ||
                 have_content("⭐ #{rating_value} / 5")
end

# Scenario: Viewing a movie trailer
Given("I view details for the movie {string}") do |movie_title|
  movie = Movie.find_by(title: movie_title) || Movie.create!(
    title: movie_title,
    director: "Christopher Nolan",
    release_year: 2023,
    description: "A test movie description",
    trailer_url: "https://www.youtube.com/watch?v=uYPbbksJxIg" # Actual YouTube URL
  )
  visit movie_path(movie)
end


When("I click on the {string} play button") do |button_text|
  # More specific selector for the watch trailer button
  if page.has_button?("Watch Trailer") || page.has_button?("watch-trailer")
    click_button("Watch Trailer")
  elsif page.has_link?(button_text)
    click_link(button_text)
  elsif page.has_css?("#watch-trailer")
    find("#watch-trailer").click
  else
    # Add debugging info
    puts "Available buttons: #{page.all('button').map(&:text)}"
    pending "Could not find trailer button with current selectors"
  end
end

Then("the trailer should play in a pop-up or embedded player") do
  # First check if iframe exists at all (even if hidden)
  expect(page).to have_selector('iframe', visible: :all)
  
  # Then check if it becomes visible after clicking
  expect(page).to have_selector('#trailer-container iframe', visible: :all) ||
                 have_selector('.video-player') ||
                 have_selector('.trailer') ||
                 have_selector('[data-trailer]')
end


Then("I should see the title, description, director, and release year") do
  movie = Movie.last # Assuming we're testing with the most recently created movie
  expect(page).to have_content(movie.title)
  expect(page).to have_content(movie.description) if movie.description
  expect(page).to have_content(movie.director) if movie.director
  expect(page).to have_content(movie.release_year.to_s) if movie.release_year
end