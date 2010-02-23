Feature: Automating creation of onboard user object model
  In order to use CaaS
  As an onboard user
  I want an object hierarchy created so that I can create Virtual Machines.

  Background:
    Given an authenticated onboard user session

  Scenario: Onboard user cloud object exists
    Then a cloud object shall exist with the following attributes
     | attribute   | value                                                        |
     | uri         | /accounts/443/clouds/307                                     |
     | description | Created by OnboardingService on 2010-02-17T17:59:53.59-05:00 |
     | name        | cloud-307                                                    |
   And one vdc with URI
     | attribute   | value                                                        |
     | vdc-290     | /accounts/443/clouds/307/vdcs/290                            |

   Scenario: Onboard user vdc object exists
    Then a vdc object shall exist with the following attributes
     | attribute       | value                                                        |
     | uri             | /accounts/443/clouds/307/vdcs/290                            |
     | vmtemplates_uri | /vmtemplates                                                 |
     | location_uri    | /locations/8                                                 |
     | description     | Created by OnboardingService on 2010-02-17T17:59:53.66-05:00 |
     | name            | vdc-290                                                      |
     | root_cluster    | *                                                            |
     | volumes         | *                                                            |
    And the root_cluster shall have URI    
     | attribute       | value                                                        |
     | uri             | /accounts/443/clouds/307/vdcs/290/clusters/281               |
    And there will be one volume with URI
     | attribute       | value                                                        |
     | uri             | /accounts/443/clouds/307/vdcs/290/volumes/165                |

   
   Scenario: Onboard user cluster object exists
    Then a cluster object shall exist with the following attributes
     | attribute       | value                                                    |
     | uri             | /accounts/443/clouds/307/vdcs/290/clusters/281           |
     | parent_uri      | /accounts/443/clouds/307/vdcs/290                        |
     | description     | Root Cluster                                             |
     | name            | cluster-281                                              |
     | controllers     | *                                                        |
     | vnets           | *                                                        |
    And two controllers with URIs
     | attribute       | value                                                    |
     | stop            | /accounts/443/clouds/307/vdcs/290/clusters/281/stop      |
     | start           | /accounts/443/clouds/307/vdcs/290/clusters/281/start     |
    And two vnets with URIs   
     | attribute       | value                                                    |
     | 0               | /accounts/443/clouds/307/vdcs/290/clusters/281/vnets/301 |
     | 1               | /accounts/443/clouds/307/vdcs/290/clusters/281/vnets/302 |

   Scenario: Onboard user volume object exists
    Then a volume object shall exist with the following attributes
     | attribute       | value                                                        |
     | uri             | /accounts/443/clouds/307/vdcs/290/volumes/165                |
     | vdc_uri         | /accounts/443/clouds/307/vdcs/290                            |
     | description     | Created by OnboardingService on 2010-02-17T17:59:54.94-05:00 |
     | name            | volume-165                                                   |
     | webdav          | nfs://172.16.90.2:/export/SUNNFSL16                          |
     | tags            | ["/accounts/443/clouds/307/vdcs/290/clusters/281/vnets/302"] |

   Scenario: Onboard user vnet objects exists
    Then two vnets shall exist
    And the first vnet shall have the following attributes 
     | attribute       | value                                                        |
     | uri             | /accounts/443/clouds/307/vdcs/290/clusters/281/vnets/301     |
     | description     | Created by OnboardingService on 2010-02-17T17:59:54.50-05:00 |
     | name            | vnet-281                                                     |
     | tags            | ["208"]                                                      |
    And the second vnet shall have the following attributes
     | attribute       | value                                                        |
     | uri             | /accounts/443/clouds/307/vdcs/290/clusters/281/vnets/302     |
     | description     | Created by OnboardingService on2010-02-17T17:59:54.72-05:00  |
     | name            | vnet-281                                                     |
     | tags            |  ["340"]                                                     |
 