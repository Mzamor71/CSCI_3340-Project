# Rating Features
  Scenario: Successfully rate a movie
    Given I am logged in as "user1"
    And I navigate to the movie "Inception"
    When I submit a rating of 5 stars
    Then I should see my rating displayed
    And the overall rating should be updated

  Scenario: Attempt to rate without logging in
    Given I am not logged in
    And I navigate to the movie "Interstellar"
    When I try to submit a rating of 4 stars
    Then I should see an error message "You must be logged in to rate movies."

  Scenario: User tries to rate the same movie twice
    Given I am logged in as "user1"
    And I have already rated the movie "The Dark Knight" with 5 stars
    When I try to submit a rating of 3 stars
    Then I should see a message "You have already rated this movie."
    And my rating should remain unchanged

  Scenario: Submitting an invalid rating
    Given I am logged in as "user2"
    And I navigate to the movie "Tenet"
    When I try to submit a rating of -1 stars
    Then I should see an error message "Invalid rating. Please enter a value between 1 and 5."

  Scenario: Editing a rating
    Given I am logged in as "user1"
    And I have rated the movie "Inception" with 4 stars
    When I update my rating to 5 stars
    Then I should see my updated rating displayed
    And the overall rating should be recalculated