require "rails_helper"

RSpec.feature "Comment Feature", type: :feature do
  let!(:movie) { Movie.create!(title: "Inception") }
  let!(:alice) do
    User.create!(
      username: "Alice",
      email: "alice@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end
  let!(:charlie) do
    User.create!(
      username: "Charlie",
      email: "charlie@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end
  let!(:user2) do
    User.create!(
      username: "user2",
      email: "user2@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  before do
    Rating.create!(user: alice, movie: movie, stars: 5)
  end

  scenario "Charlie leaves a comment on Alice's rating" do
    login_as(charlie, scope: :user)
    visit movie_path(movie)

    within(".ratings-section") do
      expect(page).to have_content("Alice rated it 5 stars")
      find(".rating-item", text: "Alice").click_link_or_button("Comment")

      within(".comment-form") do
        fill_in "comment[content]", with: "Great rating! I totally agree."
        click_button "Submit Comment"
      end

      within(".rating-item", text: "Alice") do
        expect(page).to have_content("Charlie")
        expect(page).to have_content("Great rating! I totally agree.")
      end
    end
  end

  scenario "user2 likes Charlie's comment" do
    rating = Rating.find_by(user: alice, movie: movie)
    Comment.create!(
      user: charlie,
      rating: rating,
      content: "This is a test comment from Charlie",
      likes_count: 0
    )

    login_as(user2, scope: :user)
    visit movie_path(movie)

    within(".rating-item", text: "Alice") do
      within(".comment-item", text: "Charlie") do
        expect(page).to have_content("0 likes")
        click_button "Like"
        expect(page).to have_content("1 like")
      end
    end
  end
end
