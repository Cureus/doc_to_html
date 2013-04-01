module DocToHtml
  class Converter
    attr_reader :file_path
    attr_accessor :conversion

    def initialize(file_path)
      @file_path = file_path
    end

    def convert!
      uploaded_file = upload_file
      converted_file = convert_file(uploaded_file)
      converted_file.rewind
      converted_file.readline
    end
    
    def upload_file
      @uploaded_file ||= google_drive_session.upload_from_file(file_path) 
    end
    
    def convert_file(google_drive_file)
      return conversion if conversion
      @conversion = Tempfile.new('converted_file')
      conversion.binmode
      google_drive_file.download_to_io(conversion, content_type: "text/html")
      conversion
    end

    def google_drive_session
      @google_drive_session ||= GoogleDrive.login(DocToHtml.configuration.username, DocToHtml.configuration.password)
    end
  end
end
