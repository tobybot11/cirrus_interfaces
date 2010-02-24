Feature: Virtual Machine physical location
  In order to determine or specify the physical location of a virtual machine 
  As an authenticated user
  I need to be able to retrieve the supported physical locations.

  Scenario: Retrieve all available physical locations
    Given an authenticated onboard user session
    Then one location shall be available
    And one of the locations shall be named "Pitscataway" and have the following attributes
     | attribute   | value                                  |
     | uri         | /locations/8                           |
     | name        | Pitscataway                            |
     | description | This IDC is located at Pitscataway, NJ |    

