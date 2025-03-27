 Feature: Search

 As "name" user
 I want to search for a movie
 So that i can rate it on the site

 # Search Features
  Scenario: Searching for a movie
    Given I am on the homepage
    When I search for "Dunkirk"
    Then I should see "Dunkirk" in the search results
    And I should be able to click on the movie to view its details

  Scenario: Searching for a non-existent movie
    Given I am on the homepage
    When I search for "Unknown Movie XYZ"
    Then I should see a message "No results found."

  Scenario: Filtering movies by genre
    Given I am on the homepage
    When I select the "Science Fiction" genre
    Then I should see a list of movies that belong to the "Science Fiction" genre