module DocToHtml
  class Converter
    attr_reader :file_path
    attr_accessor :conversion, :google_drive_file, :conversion

    def initialize(file_path)
      @file_path = file_path
    end

    def convert!
      @google_drive_file = upload_file
      converted_file = convert_file
      converted_file.rewind
      output = converted_file.readlines
      (output.is_a?(Enumerable)) ? (output.join(' ')) : (output)
    end
    
    def upload_file
      @uploaded_file ||= google_drive_session.upload_from_file(file_path) 
    end
    
    def convert_file
      return conversion if conversion
      @conversion = Tempfile.new('converted_file')
      conversion.binmode
      download_html_from_google
      conversion
    end

    def google_drive_session
      @google_drive_session ||= GoogleDrive.login(DocToHtml.configuration.username, DocToHtml.configuration.password)
    end

    def download_html_from_google
      if google_drive_file.resource_type == "spreadsheet"
        conversion.write(google_drive_file.export_as_string("html")) 
      else
        google_drive_file.download_to_io(conversion, content_type: "text/html")
      end
    end
  end
end
