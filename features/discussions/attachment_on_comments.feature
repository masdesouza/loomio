Feature: Attachments on comments
  In order to be able to share relevant documents and files
  As a user
  I need to be able to attach files to comments

  Background:
    Given I am logged in
    And I belong to a group with a discussion
    And I am on the discussion page

  @javascript
  Scenario: User attaches file and posts comment
    # And screenshot
    # When I attach a file
    And  I post a comment
    Then I should see the posted comment with the attachment

  @javascript
  Scenario: User attaches file, cancels upload and posts comment
    When I attach a file and cancel the upload
    And I post a comment
    Then I should see the posted comment without an attachment

  @javascript
  Scenario: User attaches file, removes attachment and posts comment
    When I attach a file
    And remove the file
    And I post a comment
    Then I should see the posted comment without an attachment

  @javascript
  Scenario: User cannot attach oversized file
    When I attach an oversized file
    Then I should be told the file is oversized
