require 'rails_helper'
include Warden::Test::Helpers   

RSpec.feature "Comment Feature", type: :feature do
  let!(:genre) { Genre.create!(name: "Sci-Fi") }
  let!(:movie) { Movie.create!(title: "Inception", genres: [genre]) }
  let!(:rating) { Rating.create!(user: alice, movie: movie, stars: 5) }
  let!(:alice) { User.create!(username: "Alice", email: "alice@example.com", password: "password") }
  let!(:charlie) { User.create!(username: "Charlie", email: "charlie@example.com", password: "password") }
  let!(:user2) { User.create!(username: "user2", email: "user2@example.com", password: "password") }

  scenario "Charlie leaves a comment on Alice's rating" do
    login_as(charlie)
    visit movie_path(movie)

    within(".rating-#{rating.id}") do
      fill_in "Your Comment", with: "Great rating! I totally agree."
      click_button "Submit Comment"
    end

    expect(page).to have_content("Great rating! I totally agree.")
    expect(page).to have_content("Charlie")
  end

  scenario "User2 likes Charlie's comment" do
    comment = Comment.create!(user: charlie, rating: rating, content: "Great rating! I totally agree.")
    login_as(user2)
    visit movie_path(movie)

    within(".comment-#{comment.id}") do
      click_button "Like"
    end

    expect(page).to have_content("1 like")
  end
end
