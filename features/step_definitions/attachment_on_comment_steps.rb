When(/^I write a comment, select a file to attach and click submit$/) do
  @comment_text = 'Test comment, with _markdown_'
  fill_in 'new-comment', with: @comment_text

  # find("#upload-attachment").click
  @filename = 'circlelogo.png'
  attach_file('file', File.join(Rails.root, "app/assets/images/#{@filename}"))
  click_on 'post-new-comment'
end

Then(/^I should see the file name$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a progress bar for the attachment upload$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a cancel button for the attachment upload$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should not see a progress bar$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a cancel button for the attachment$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I click submit$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see my comment$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^there should be a link to the attachment$/) do
  pending # express the regexp above with the code you wish you had
end
