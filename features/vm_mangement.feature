Feature: Managment of Virtual Machines
  In order to manage Virtual Machines
  As an authenticated user
  I need to be able to create/update/delete Virtual Machines, manage run state of Virtual Machines and attach storage 
  Volumes to Virtual Machines.

  Background:
    Given an authenticated onboard user session

  Scenario: Create and Delete a Virtual Machine and verify attributes
    Given the following Virtual Machine Configuration
     | attribute   | value            |
     | name        | Cuke Test VM     |
     | description | Cucumber test VM |
     | vmtemplate  | RHEL5-Small      |
    Then create a Virtual Machine which shall have the following attributes
     | attribute         | value                                                        |
     | name              | Cuke Test VM                                                 |
     | uri               | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*         |
     | description       | Cucumber test VM                                             |
     | hostname          | *                                                            |
     | os                | Red Hat Enterprise Linux 5 (64-bit)                          |
     | run_state         | STARTED                                                      |
     | memory            | 4096MB of memory                                             |
     | data_disk         | 104857600                                                    |
     | cpu               | 1 virtual CPU(s)                                             |
     | cluster_uri       | /accounts/443/clouds/307/vdcs/290/clusters/281               |
     | from_template_uri | /vmtemplates/25                                              |
     | controllers       | *                                                            |
     | interfaces        | *                                                            |
    And three controllers with the following URIs 
     | attribute       | value                                                          |
     | stop            | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*/stop      |
     | reboot          | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*/reboot    |
     | hibernate       | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*/hibernate |
    And the following interface attributes
     | attribute       | value                                                          |
     | mac_address     | not_available                                                  |
     | nic             | PCNet32 ethernet adapter on "Internal" network                 |
     | public_address  | *                                                              |
     | ip_address      | *                                                              |
     | vnet_uri        | /accounts/443/clouds/307/vdcs/290/clusters/281/vnets/*         |
    And it should be possible to log into the Virtual Machine through its network interface on its "public_address"
    And it should be possible to log into the Virtual Machine through its network interface on its "ip_address"
    And it should be possible to delete the Virtual Machine
   
  Scenario: Shutdown Virtual Machine
    Given a Virtual Machine started with attributes
     | attribute   | value             |
     | name        | Cuke Test VM      |
     | description | Cucumber test VM  |
     | vmtemplate  | RHEL5-Small       |
    And the following attributes after creation
     | attribute   | value   |
     | run_state   | STARTED |
    Then when the Virtual Machine is sutdown it will have the following attributes
     | attribute   | value   |
     | run_state   | STOPPED |
    And there should be one available controller
     |  attribute      | value                                                      |
     | start           | /accounts/443/clouds/307/vdcs/290/clusters/281/vms/*/start |
    And it should not be possible to log into the Virtual Machine through its network interface on its "public_address"
    And it should not be possible to log into the Virtual Machine through its network interface on its "ip_address"
    And it should be possible to delete the Virtual Machine

  Scenario: Restart STOPPED Virtual Machine
    Given a Virtual Machine started with attributes
     | attribute   | value             |
     | name        | Cuke Test VM      |
     | description | Cucumber test VM  |
     | vmtemplate  | RHEL5-Small       |
    And and then shutdown with the following attributes
     | attribute   | value   |
     | run_state   | STOPPED |
    Then if it is restarted it will have the following run_state
     | attribute  | value    |
     | run_state  | STARTED  |
    And it should be possible to log into the Virtual Machine through its network interface on its "public_address"
    And it should be possible to log into the Virtual Machine through its network interface on its "ip_address"
    And it should be possible to delete the Virtual Machine

  Scenario: Reboot Virtual Machine
    Given a Virtual Machine started with attributes
     | attribute   | value            |
     | name        | Cuke Test VM     |
     | description | Cucumber test VM |
     | vmtemplate  | RHEL5-Small      |
    Then if it is rebooted it will have the following run_state
     | attribute | value    |
     | run_state | STARTED  |
    And it should be possible to log into the Virtual Machine through its network interface on its "public_address"
    And it should be possible to log into the Virtual Machine through its network interface on its "ip_address"
    And it should be possible to delete the Virtual Machine

  Scenario: Validate support for RHEL5-Small Virtual Machine
    Given the following Virtual Machine configuration
     | attribute   | value            |
     | name        | Cuke Test VM     |
     | description | Cucumber test VM |
    Then create a "RHEL5-Small" Virtual Machine
    And it should have the following attributes
     | attribute         | value                               |
     | os                | Red Hat Enterprise Linux 5 (64-bit) |
     | run_state         | STARTED                             |
     | memory            | 4096MB of memory                    |
     | data_disk         | 104857600                           |
     | cpu               | 1 virtual CPU(s)                    |
     | from_template_uri | /vmtemplates/25                     |
    And it should be possible to log into the Virtual Machine through its network interface on its "public_address"
    And it should be possible to log into the Virtual Machine through its network interface on its "ip_address"
    And it should be possible to mount a Volume and write a file to the volume 
    And it should be possible to delete the Virtual Machine

  Scenario: Validate support for RHEL5-Medium Virtual Machine
    Given the following Virtual Machine configuration
     | attribute   | value            |
     | name        | Cuke Test VM     |
     | description | Cucumber test VM |
    Then create a "RHEL5-Medium" Virtual Machine
    And it should have the following attributes
     | attribute         | value                               |
     | os                | Red Hat Enterprise Linux 5 (64-bit) |
     | run_state         | STARTED                             |
     | memory            | 8192MB of memory                    |
     | data_disk         | 104857600                           |
     | cpu               | 2 virtual CPU(s)                    |
     | from_template_uri | /vmtemplates/25                     |
    And it should be possible to log into the Virtual Machine through its network interface on its "public_address"
    And it should be possible to log into the Virtual Machine through its network interface on its "ip_address"
    And it should be possible to mount a Volume and write a file to the volume 
    And it should be possible to delete the Virtual Machine

  Scenario: Validate support for RHEL5-Large Virtual Machine
    Given the following Virtual Machine configuration
     | attribute   | value            |
     | name        | Cuke Test VM     |
     | description | Cucumber test VM |
    Then create a "RHEL5-Large" Virtual Machine
    And it should have the following attributes
     | attribute         | value                               |
     | os                | Red Hat Enterprise Linux 5 (64-bit) |
     | run_state         | STARTED                             |
     | memory            | 16384MB of memory                   |
     | data_disk         | 104857600                           |
     | cpu               | 4 virtual CPU(s)                    |
     | from_template_uri | /vmtemplates/25                     |
    And it should be possible to log into the Virtual Machine through its network interface on its "public_address"
    And it should be possible to log into the Virtual Machine through its network interface on its "ip_address"
    And it should be possible to mount a Volume and write a file to the volume 
    And it should be possible to delete the Virtual Machine

  Scenario: Validate support for W2K8-Small Virtual Machine
    Given the following Virtual Machine configuration
     | attribute   | value            |
     | name        | Cuke Test VM     |
     | description | Cucumber test VM |
    Then create a "W82K-Small" Virtual Machine
    And it should have the following attributes
     | attribute         | value                                  |
     | os                | Microsoft Windows Server 2008 (64-bit) |
     | run_state         | STARTED                                |
     | memory            | 4096MB of memory                       |
     | data_disk         | 104857600                              |
     | cpu               | 1 virtual CPU(s)                       |
     | from_template_uri | /vmtemplates/25                        |
    And it should be possible to ping the Virtual Machine through its network interface on its "public_address"
    And it should be possible to ping the Virtual Machine through its network interface on its "ip_address"
    And it should be possible to delete the Virtual Machine

  Scenario: Validate support for W2K8-Medium Virtual Machine
    Given the following Virtual Machine configuration
     | attribute   | value            |
     | name        | Cuke Test VM     |
     | description | Cucumber test VM |
    Then create a "W82K-Medium" Virtual Machine
    And it should have the following attributes
     | attribute         | value                                  |
     | os                | Microsoft Windows Server 2008 (64-bit) |
     | run_state         | STARTED                                |
     | memory            | 8192MB of memory                       |
     | data_disk         | 104857600                              |
     | cpu               | 2 virtual CPU(s)                       |
     | from_template_uri | /vmtemplates/25                        |
    And it should be possible to ping the Virtual Machine through its network interface on its "public_address"
    And it should be possible to ping the Virtual Machine through its network interface on its "ip_address"
    And it should be possible to delete the Virtual Machine

  Scenario: Validate support for W2K8-Large Virtual Machine
    Given the following Virtual Machine configuration
     | attribute   | value            |
     | name        | Cuke Test VM     |
     | description | Cucumber test VM |
    Then create a "W82K-Large" Virtual Machine
    And it should have the following attributes
     | attribute         | value                                  |
     | os                | Microsoft Windows Server 2008 (64-bit) |
     | run_state         | STARTED                                |
     | memory            | 16384MB of memory                      |
     | data_disk         | 104857600                              |
     | cpu               | 4 virtual CPU(s)                       |
     | from_template_uri | /vmtemplates/25                        |
    And it should be possible to ping the Virtual Machine through its network interface on its "public_address"
    And it should be possible to ping the Virtual Machine through its network interface on its "ip_address"
    And it should be possible to delete the Virtual Machine
