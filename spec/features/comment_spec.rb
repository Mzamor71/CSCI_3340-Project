require 'rails_helper'

RSpec.feature "Comment Feature", type: :feature do
  let!(:genre) { Genre.create!(name: "Sci-Fi") }
  let!(:movie) { Movie.create!(title: "Inception") }
  
  before(:each) do
    # Sign up Alice
    visit '/users/sign_up' # Adjust this path if needed
    
    # Update field names to match your actual form fields
    # These are common field names in Devise forms
    fill_in "user[username]", with: "Alice"
    fill_in "user[email]", with: "alice@example.com"
    fill_in "user[password]", with: "password"
    fill_in "user[password_confirmation]", with: "password"
    click_button "Sign up"
    
    visit movie_path(movie)
    # Make sure this field name matches your actual rating form
    choose "rating_stars_4"
    click_button "Submit Rating"
    click_link "Logout" # Adjust button text if different
    
    # Sign up Charlie
    visit '/users/sign_up' # Adjust path if needed
    fill_in "user[username]", with: "Charlie"
    fill_in "user[email]", with: "charlie@example.com"
    fill_in "user[password]", with: "password"
    fill_in "user[password_confirmation]", with: "password"
    click_button "Sign up"
  end
  
  scenario "Charlie leaves a comment on Alice's rating" do
    visit movie_path(movie)
    
    # Update to match your comment form field names
    fill_in "comment[content]", with: "Great review, Alice!"
    click_button "Post Comment"
    
    expect(page).to have_content("Great review, Alice!")
    expect(page).to have_content("Charlie")
  end
  
  scenario "Another user likes Charlie's comment" do
    visit movie_path(movie)
    fill_in "comment[content]", with: "Nice one!"
    click_button "Post Comment"
    click_link "Log out" # Adjust button text if different
    
    # Sign up user2
    visit '/users/sign_up' # Adjust path if needed
    fill_in "user[username]", with: "User2"
    fill_in "user[email]", with: "user2@example.com"
    fill_in "user[password]", with: "password"
    fill_in "user[password_confirmation]", with: "password"
    click_button "Sign up"
    
    visit movie_path(movie)
    
    # Find the specific like button - add a more specific selector if needed
    within('.comments-section') do
      click_button "Like"
    end
    
    expect(page).to have_content("1 like")
  end
end
