require 'spec_helper'

describe Email do
  describe 'substitute_placeholders' do
    let(:user) { stub(:user, name: 'bill jones') }
    let(:email) { Email.new }

    before do
      email.subject = "open this email please {{@recipient.name}}"
      email.body = "hi {{@recipient.name}} click this link {{root_url}}"
      email.substitute_placeholders(recipient: user)
    end

    it "replaces object.method placeholders" do
      email.subject.should == 'open this email please bill jones'
      email.body.should == 'hi bill jones click this link http://localhost:3000/'
    end
  end
end
