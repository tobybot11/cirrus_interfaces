Feature: Start CaaS Session
  In order to use CaaS
  As administrator or user
  I want start a session.

  Scenario: An admin provides valid authentication credentials
    Given a valid "admin" user ID and a valid password
    Then a valid CaaS "admin" session can be created with the following attributes
    | attribute      | value |
    | authentication |   *   |
    
