Feature: Automating creation of onboard user object model
  In order to use CaaS
  As an onboard user
  I want an object hierarchy created so that I can create Virtual Machines.

  Background:
    Given an onboard user session

  Scenario: Onboard user cloud object exists
    Then a cloud object shall exist with the following attributes
     | attribute   | value                                                        |
     | uri         | /accounts/327/clouds/270                                     |
     | description | Created by OnboardingService on 2010-01-26T16:34:29.18-05:00 |
     | name        | cloud-270                                                    |
   And one vdc with URI
     | attribute   | value                                                        |
     | vdc-253     | /accounts/327/clouds/270/vdcs/253                            |

   Scenario: Onboard user vdc object exists
    Then a vdc object shall exist with the following attributes
     | attribute       | value                                                        |
     | uri             | /accounts/327/clouds/270/vdcs/253                            |
     | vmtemplates_uri | /vmtemplates                                                 |
     | location_uri    | /locations/8                                                 |
     | description     | Created by OnboardingService on 2010-01-26T16:34:29.33-05:00 |
     | name            | vdc-253                                                      |
     | root_cluster    | *                                                            |
     | volumes         | *                                                            |
    And the root_cluster shall have URI    
     | attribute       | value                                                        |
     | uri             | /accounts/327/clouds/270/vdcs/253/clusters/244               |
    And there will be one volume with URI
     | attribute       | value                                                        |
     | uri             |  /accounts/327/clouds/270/vdcs/253/volumes/128               |

   
   Scenario: Onboard user cluster object exists
    Then a cluster object shall exist with the following attributes
     | attribute       | value                                                    |
     | uri             | /accounts/327/clouds/270/vdcs/253/clusters/244           |
     | parent_uri      | /accounts/327/clouds/270/vdcs/253                        |
     | description     | Root Cluster                                             |
     | name            | cluster-244                                              |
     | controllers     | *                                                        |
     | vnets           | *                                                        |
     | vms             | *                                                        |
    And two controllers with URIs
     | attribute       | value                                                    |
     | stop            | /accounts/327/clouds/270/vdcs/253/clusters/244/stop      |
     | start           | /accounts/327/clouds/270/vdcs/253/clusters/244/start     |

    And two vnets with URIs   
     | attribute       | value                                                    |
     | 0               | /accounts/327/clouds/270/vdcs/253/clusters/244/vnets/227 |
     | 1               | /accounts/327/clouds/270/vdcs/253/clusters/244/vnets/228 |

   Scenario: Onboard user volume object exists
    Then a volume object shall exist with the following attributes
     | attribute       | value                                                        |
     | uri             | /accounts/327/clouds/270/vdcs/253/volumes/128                |
     | vdc_uri         | /accounts/327/clouds/270/vdcs/253                            |
     | description     | Created by OnboardingService on 2010-01-26T16:34:30.74-05:00 |
     | name            | volume-128                                                   |
     | webdav          | nfs://172.16.45.2:/export/SUNNFSL9                           |
     | tags            | ["/accounts/327/clouds/270/vdcs/253/clusters/244/vnets/228"] |

   Scenario: Onboard user vnet objects exists
    Then two vnets shall exist
    And the first vnet shall have the following attributes 
     | attribute       | value                                                        |
     | uri             | /accounts/327/clouds/270/vdcs/253/clusters/244/vnets/227     |
     | cluster_uri     | *                                                            |
     | description     | Created by OnboardingService on 2010-01-26T16:34:30.30-05:00 |
     | name            | vnet-244                                                     |
     | tags            | ["209"]                                                      |
    And the second vnet shall have the following attributes
     | attribute       | value                                                       |
     | uri             | /accounts/327/clouds/270/vdcs/253/clusters/244/vnets/228    |
     | cluster_uri     | *                                                           |
     | description     | Created by OnboardingService on2010-01-26T16:34:30.52-05:00 |
     | name            | vnet-244                                                    |
     | tags            |  ["345"]                                                    |
 