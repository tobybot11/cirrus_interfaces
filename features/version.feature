Feature: Cirrus API Version Number
  In order to determine the Cirrus API Version Number
  As an unauthenticated user
  I need to be able to retrieve the Cirrus API Version Number.

  Scenario: Retrieve Cirrus API Version
    Given that the user is not authenticated
    Then it shall be possible to retrieve the Cirrus API Version object with the following attributes
     | attribute                     | value                 |
     | X-Cloud-Specification-Version | 0.1                   |
