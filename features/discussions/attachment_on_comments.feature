Feature: Attachments on comments
  In order to be able to share relevant documents and files
  As a user
  I need to be able to attach files to comments

  @javascript
  Scenario: Member attaches files and posts comment
    Given I am logged in
    And there is a discussion in a group I belong to
    When I visit the discussion page
    And I write a comment, select a file to attach and click submit
    And screenshot
    Then I should see the file name
    And I should see a progress bar for the attachment upload
    And I should see a cancel button for the attachment upload

    When I wait 5 seconds
    Then I should not see a progress bar
    And I should see a cancel button for the attachment

    When I click submit
    Then I should see my comment
    And there should be a link to the attachment


  Scenario: Member attaches a file, then removes the file and posts the comment

  Scenario: Member starts attaching a file, cancels file upload, then attaches another file and posts comment

  Scenario: Member starts attaching a file and tries to post comment whilst file is uploading

  Scenario: Member starts attaching a file and tries to attach another file while file is uploading

  Scenario: Member starts attaching a file and connection fails

  Scenario: Member tries to upload a 500MB file


