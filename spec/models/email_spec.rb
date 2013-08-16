require 'spec_helper'

describe Email do
  describe 'substitute_placeholders' do
    let(:user) { stub(:user, name: 'bill jones') }

    before do
      email.subject = "open this email please {{recipient.name}}"
      email.body = "hi {{recipient.name}} click this link {{root_url}}"
      email.substitute_placeholders(recipient: user)
    end

    it "replaces object.method placeholders" do
      email.subject.should == 'open this email please bill jones'
      email.body.should =~ /^hi bill jones/
    end

    it "replaces url helper placeholders" do
      email.body.should =~ /http:\/\/something\//
    end
  end
end
