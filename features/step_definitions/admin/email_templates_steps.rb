Given(/^I am a logged in system admin$/) do
  @admin = FactoryGirl.create(:user, is_admin: true)
  login_automatically(@admin)
end

When(/^I visit the admin email templates page$/) do
  visit admin_email_templates_path
end

When(/^fill in and submit the email template form$/) do
  fill_in 'Name', with: 'start a discussion reminder'
  select 'English', from: 'Language'
  fill_in 'Subject', with: 'We reckon you need to start a discussion in your group'
  fill_in 'Body', with: <<-body
  Hi {{@recipient.first_name}},
  ============================

  We're really pleased you started a loomio group, but we're sad that
  nothing has been going on in it.

  Why dont you head over to the [start discussion page]({{new_discussion_path}}) and start one?

  - this
  - is
  - a
  - list

  Thanks for your time
  {{@author.first_name}}
  body
  click_on 'Create Email template'
end

Then(/^I should see the email template was created$/) do
  page.should have_content 'Email template was successfully created.'
end

Given(/^there is an email template$/) do
  @email_template = FactoryGirl.create(:email_template)
end

When(/^I visit the email templates page$/) do
  visit admin_email_templates_path
end

When(/^I click to preview the email template$/) do
  click_on 'View'
end

Then(/^I should see how the email template will look when sent$/) do
  page.should have_content("Hi Loomio")
end

Given(/^a group exists$/) do
  @group = FactoryGirl.create :group
end

When(/^I visit the admin groups page and click email$/) do
  visit admin_groups_path
  view_screenshot
  check :"batch_action_item_#{@group.id}"
  click_on 'Batch Actions'
  click_on 'Email Selected'
end

When(/^I choose my template and the group contact person$/) do
  select @email_template.name, from: 'Email template'
  select 'contact_person', from: 'Recipients'
end

Then(/^a pending email to the group contact person, based on the template, should be created$/) do
  email = Email.last
  email.to.should include @group.contact_person.name_and_email
end

Given(/^an email has been generated from a template$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I visit the outbound emails page$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I click to preview the email$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see what the email will look like to the user$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I click to edit the email$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the email form with markdown preserved but placeholders replaced$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I send the email$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the email should be sent to the recipient$/) do
  pending # express the regexp above with the code you wish you had
end

