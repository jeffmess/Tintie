require 'spec_helper'

describe "Navigation" do
  include Capybara
  
  it "should be a valid app" do
    ::Rails.application.should be_a(Dummy::Application)
  end
  
  context "I'm on the Tasks page" do
    before { 
      controller.stub!(:current_user).and_return(@current_user)
      visit tasks_url 
    }
  end
end
