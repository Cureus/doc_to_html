require "spec_helper"

describe DocToHtml::Converter do
  let(:mock_session) { GoogleDrive::Session.new }
  let(:mock_file_path) { '/foo/bar/baz.docx' }
  let(:converter) { DocToHtml::Converter.new(mock_file_path) }

  describe "#google_drive_session" do
    it "returns a valid google drive session" do
      GoogleDrive.should_receive(:login).with("username", "password") { mock_session }
      converter.google_drive_session.should == mock_session
    end
  end

  describe "#initialize" do
    it "should set the file path" do
      converter.file_path.should == mock_file_path
    end
  end

  context "with a valid login to GoogleDrive" do
    before do
      GoogleDrive.stub(:login).with("username", "password") { mock_session }
    end

    context "with a DocToHtml::Converter" do
      describe "#convert!" do
        let(:converted_file_mock) { mock(readline: "some htmls") }

        before do
          converter.stub(:convert_file) { converted_file_mock }
          converted_file_mock.stub(:rewind)
        end

        it "should get a file from the google drive session" do
          converter.should_receive(:upload_file)
          converter.convert!
        end

        it "should call convert_file on the newly uploaded file" do
          uploaded_file = mock("uploaded file")
          converter.stub(:upload_file) { uploaded_file }
          converter.should_receive(:convert_file)
          converter.convert!
        end

        it "should rewind the file" do
          converter.stub(:upload_file)
          converted_file_mock.should_receive(:rewind)
          converter.convert!
        end

        it "should return the contents of the file" do
          converter.stub(:upload_file)
          converter.convert!.should == "some htmls"
        end
      end

      describe "#upload_file!" do
        it "uploads the file to google drive" do
          mock_session.should_receive(:upload_from_file).with(mock_file_path)
          converter.upload_file
        end
      end

      describe "#convert_file!" do
        let(:google_drive_file) { mock("google file") }

        before do
          converter.stub(:google_drive_file).and_return(google_drive_file)
        end

        context "when the google_drive_file is NOT XLS" do
          before do
            google_drive_file.stub(:resource_type).and_return("NOT XLS")
          end

          it "creates a new tempfile with the html-formatted google drive file" do
            google_drive_file.should_receive(:download_to_io) 
            converter.convert_file
          end
        end

        context "when the google_drive_file IS XLS" do
          before do
            google_drive_file.stub(:resource_type).and_return("spreadsheet")
          end

          it "creates a new tempfile with the html-formatted google drive file" do
            google_drive_file.should_receive(:export_as_string) 
            converter.convert_file
          end
        end
      end
    end
  end
end
