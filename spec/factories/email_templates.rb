# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_template do
    name 'start a discussion reminder'
    language 'en'
    subject 'We reckon you need to start a discussion in your group'
    body <<-body
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
  end
end
