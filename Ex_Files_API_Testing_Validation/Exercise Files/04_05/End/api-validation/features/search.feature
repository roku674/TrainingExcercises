Feature: Search

  Scenario: something
    Given I am an anonymous user
    When I search for behat
    Then I expect a 200 response code
    And I expect at least 1 result