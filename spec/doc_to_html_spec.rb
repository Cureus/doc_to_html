require "spec_helper"

describe DocToHtml do
  after(:each) do
    #Reset the configuration to prevent test pollution
    DocToHtml.configure do |config|
      config.username = "username"
      config.password = "password"
    end
  end

  it "can be configured" do
    DocToHtml.configure do |config|
      config.username = "googles"
      config.password = "new pass"
    end

    DocToHtml.configuration.username.should == "googles"
    DocToHtml.configuration.password.should == "new pass"
  end
end
