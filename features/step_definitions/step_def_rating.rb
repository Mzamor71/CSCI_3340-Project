# Scenario: Successfully rate a movie
Given("I am logged in as {string}") do |username|
  # Check if user exists, create if not
  user = User.find_by(username: username) || User.create!(
    username: username,
    email: "#{username}@example.com",
    password: "password123",
    password_confirmation: "password123"
  )
  
  # Visit login page
  visit new_user_session_path
  
  # Fill in credentials
  fill_in "Email", with: user.email
  fill_in "Password", with: "password123"
  
  # Submit the form
  click_button "Log in"
  
  # Verify login was successful
  expect(page).to have_content(username) || have_content("Signed in successfully")
end

Given("I navigate to the movie {string}") do |movie_title|
  # Find or create the movie
  movie = Movie.find_by(title: movie_title) || Movie.create!(
    title: movie_title,
    description: "A movie for testing",
    director: "Test Director",
    release_year: 2020
    
  )
  
  # Visit the movie page
  visit movie_path(movie)
  expect(page).to have_content(movie_title)
end

When("I submit a rating of {int} stars") do |stars|
  # Find the rating form
  within(".rating-form") do
    find("label.star-#{stars}").click
    click_button "Submit Rating"
  end
end

Then("I should see my rating displayed") do
  within(".user-rating") do
    expect(page).to have_content("Your rating")
  end
end

Then("the overall rating should be updated") do
  expect(page).to have_css(".overall-rating")
end

# Scenario: Editing a rating
Given("I have rated the movie {string} with {int} stars") do |movie_title, stars|
  # Find or create the movie
  movie = Movie.find_by(title: movie_title) || Movie.create!(
    title: movie_title,
    description: "A movie for testing",
    director: "Test Director",
    release_year: 2020
  )
  
  # Get current user
  user = User.find_by(email: "#{page.find('.user-info').text.strip.downcase}@example.com") rescue nil
  user ||= User.last # Fallback
  
  # Create or update the rating
  rating = Rating.find_by(user_id: user.id, movie_id: movie.id)
  if rating
    rating.update!(stars: stars)
  else
    Rating.create!(user_id: user.id, movie_id: movie.id, stars: stars)
  end
  
  # Visit the movie page to see the rating
  visit movie_path(movie)
  expect(page).to have_content(movie_title)
end

When("I update my rating to {int} stars") do |new_stars|
  # Click on edit rating button
  click_link "Edit Rating"
  
  # Update the rating
  within(".rating-form") do
    find("label.star-#{new_stars}").click
    click_button "Update Rating"
  end
end

Then("I should see my updated rating displayed") do
  within(".user-rating") do
    expect(page).to have_content("Your rating")
  end
end

Then("the overall rating should be recalculated") do
  expect(page).to have_css(".overall-rating")
  
  # Check that the average rating is displayed
  expect(page).to have_content("Average Rating")
end