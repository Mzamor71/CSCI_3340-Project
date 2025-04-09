Feature: Rating

As "name" user
I want to rate a movie
So that I can leave a rating on a movie I watched

# Rating Features
  Scenario: Successfully rate a movie
    Given I am logged in as "user1"
    And I navigate to the movie "Inception"
    When I submit a rating of 5 stars
    Then I should see my rating displayed
    And the overall rating should be updated

  Scenario: Editing a rating
    Given I am logged in as "user1"
    And I have rated the movie "Inception" with 4 stars
    When I update my rating to 5 stars
    Then I should see my updated rating displayed
    And the overall rating should be recalculated