 # Viewing Features
  Scenario: Viewing average rating after multiple users rate a movie
    Given user "Alice" rated "Memento" with 4 stars
    And user "Bob" rated "Memento" with 5 stars
    When I view the movie "Memento"
    Then the average rating should be "4.5 stars"

  Scenario: Viewing a movie trailer
    Given I navigate to the movie "Oppenheimer"
    When I click on the "Watch Trailer" button
    Then the trailer should play in a pop-up or embedded player

  Scenario: Viewing movie details
    Given I navigate to the movie "Interstellar"
    When I view its details
    Then I should see the title, description, director, and release year