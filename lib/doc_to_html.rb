require "google_drive"
require "tempfile"
require_relative "doc_to_html/configuration"
require_relative "doc_to_html/converter"

module DocToHtml
  def self.configure
    yield configuration
  end

  def self.configuration
    @@configuration_instance ||= DocToHtml::Configuration.new
  end
  
  def configuration_instance
    @@configuration_instance
  end
  
  def configuration_instance=(obj)
    @@configuration_instance = obj
  end
end
