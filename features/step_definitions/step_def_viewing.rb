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
  expect(page).to have_content(expected_rating)
end

# Scenario: Viewing a movie trailer
Given("I view details for the movie {string}") do |movie_title|
  movie = Movie.find_by(title: movie_title) || Movie.create!(
    title: movie_title,
    trailer_url: "https://example.com/trailers/#{movie_title.downcase.gsub(' ', '_')}"
  )
  visit movie_path(movie)
end


When("I click on the {string} play button") do |button_text|
  # Try different approaches to click the button
  begin
    click_button(button_text)
  rescue
    find("input[value='#{button_text}']").click
  end
end

Then("the trailer should play in a pop-up or embedded player") do
  expect(page).to have_selector('iframe.trailer-player')
end


Then("I should see the title, description, director, and release year") do
  movie = Movie.last # Assuming we're testing with the most recently created movie
  expect(page).to have_content(movie.title)
  expect(page).to have_content(movie.description) if movie.description
  expect(page).to have_content(movie.director) if movie.director
  expect(page).to have_content(movie.release_year.to_s) if movie.release_year
end