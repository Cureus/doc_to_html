module DocToHtml
  class Converter
    attr_reader :file_path

    def initialize(file_path)
      @file_path = file_path
    end

    def convert!
      uploaded_file = upload_file
      converted_file = convert_file(uploaded_file)
      converted_file.readline
    end
    
    def upload_file
      google_drive_session.upload_from_file(file_path) 
    end
    
    def convert_file(google_drive_file)
      converted_file = Tempfile.new('converted_file')
      open(converted_file, "wb") do |f|
        google_drive_file.download_to_io(f, content_type: "text/html")
      end
    end

    def google_drive_session
      @google_drive_session ||= GoogleDrive.login(DocToHtml.configuration.username, DocToHtml.configuration.password)
    end
  end
end
