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

When("I submit a rating of {int} stars") do |stars|
  # Find the rating form - this depends on your implementation
  within(".rating-form") do
    find(".star-#{stars}").click
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
  movie = Movie.find_by(title: movie_title) || Movie.create!(title: movie_title)
  
  # Find the current user (assumed to be logged in from previous step)
  user = User.find_by(email: "#{page.find('.user-info').text.downcase}@example.com") || 
         User.find_by(username: page.find('.user-info').text)
  
  # Create or update the rating
  rating = Rating.find_by(user: user, movie: movie)
  if rating
    rating.update!(stars: stars)
  else
    Rating.create!(user: user, movie: movie, stars: stars)
  end
  
  # Visit the movie page to see the rating
  visit movie_path(movie)
end

When("I update my rating to {int} stars") do |new_stars|
  # Click on edit rating button
  click_link_or_button "Edit Rating"
  # Similar to the initial rating form, but for editing
  within(".edit-rating-form") do
    find(".star-#{new_stars}").click
    click_button "Update Rating"
  end
end

Then("I should see my updated rating displayed") do
  within(".user-rating") do
    expect(page).to have_content("Your rating")
  end
end

Then("the overall rating should be recalculated") do
  # This verification is similar to the previous one
  expect(page).to have_css(".overall-rating")
  
  # You could also check that the value has changed, if you have access to the previous value
  movie = Movie.find_by(title: page.find('.movie-title').text)
  expect(page).to have_content("#{movie.average_rating} stars")
end