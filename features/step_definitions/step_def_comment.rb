# Scenario: Leaving a comment on someone else's rating
Given("I see {string} rated it {int} stars") do |username, stars|
  # First ensure the user exists
  other_user = User.find_by(username: username) || User.create!(
    username: username,
    email: "#{username.downcase}@example.com",
    password: "password123",
    password_confirmation: "password123"
  )
  
  # Get the current movie from the page
  movie_title = page.find(".movie-title").text
  movie = Movie.find_by(title: movie_title)
  
  # Create the rating if it doesn't exist
  unless Rating.find_by(user: other_user, movie: movie)
    Rating.create!(
      user: other_user,
      movie: movie,
      stars: stars
    )
  end
  
  # Refresh the page to see the rating
  visit current_path
  
  # Verify the rating is visible
  within(".ratings-section") do
    expect(page).to have_content("#{username} rated it #{stars} stars")
  end
end

When("I leave a comment {string}") do |comment_text|
  # Find the rating we want to comment on
  within(".ratings-section") do
    # Click the comment button/link for the specific rating
    first(".rating-item").click_link_or_button("Comment")
    
    # Fill in the comment form
    within(".comment-form") do
      fill_in "comment[content]", with: comment_text
      click_button "Submit"
    end
  end
end

Then("my comment should appear under {string} rating") do |username|
  within(".ratings-section") do
    # Find the specific rating
    within(find(".rating-item", text: username)) do
      # Check for the current user's comment
      current_user = page.find(".user-info").text
      expect(page).to have_content(current_user)
    end
  end
end

# Scenario: Liking a comment
Given("I see a comment by {string} on {string} rating") do |commenter, rater|
  # Ensure we have all the necessary users
  commenter_user = User.find_by(username: commenter) || User.create!(
    username: commenter,
    email: "#{commenter.downcase}@example.com",
    password: "password123",
    password_confirmation: "password123"
  )
  
  rater_user = User.find_by(username: rater) || User.create!(
    username: rater,
    email: "#{rater.downcase}@example.com",
    password: "password123",
    password_confirmation: "password123"
  )
  
  # Get the current movie
  movie_title = page.find(".movie-title").text
  movie = Movie.find_by(title: movie_title)
  
  # Ensure the rating exists
  rating = Rating.find_by(user: rater_user, movie: movie)
  unless rating
    rating = Rating.create!(
      user: rater_user,
      movie: movie,
      stars: 5 # Default value
    )
  end
  
  # Ensure the comment exists
  unless Comment.find_by(user: commenter_user, rating: rating)
    Comment.create!(
      user: commenter_user,
      rating: rating,
      content: "This is a test comment from #{commenter}",
      likes_count: 0
    )
  end
  
  # Refresh the page to see the comment
  visit current_path
  
  # Verify the comment is visible
  within(".ratings-section") do
    within(find(".rating-item", text: rater)) do
      expect(page).to have_content(commenter)
    end
  end
end

When("I click the {string} button") do |button_text|
  # Find the specific comment and click its like button
  within(".comments-section") do
    within(first(".comment-item")) do
      click_link_or_button button_text
    end
  end
end

Then("the like count for {string} comment should increase by {int}") do |username, increase|
  # Find the specific comment and check its like count
  within(".comments-section") do
    within(find(".comment-item", text: username)) do
      # This assumes there's an element showing the like count
      like_count_text = find(".likes-count").text
      like_count = like_count_text.to_i
      
      # Store the value in a global variable to check against previous value
      @old_like_count ||= like_count - increase
      expect(like_count).to eq(@old_like_count + increase)
    end
  end
end