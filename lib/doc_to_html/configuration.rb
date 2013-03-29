module DocToHtml
  class Configuration
    attr_accessor :username, :password

    def initialize
      @username = "username"
      @password = "password"
    end
  end
end
