require 'rails_helper'

RSpec.describe Gist, type: :model do
  it "takes accepts nested attributes for gist files" do
    gist = Gist.new description: "Example timey code",
      gist_files_attributes: {
        "0" => {
          file_type: "ruby", body: "def say_hi\n  puts :hi\nend"
        }
      }
      expect(gist.gist_files.to_a.count).to eq 1
  end

  it "creates multiple gist files" do
    gist = Gist.new description: "Example timey code",
                    gist_files_attributes: {
                        "0" => {
                            file_type: "ruby", body: "def say_hi\n  puts :hi\nend"
                        },
                        "1" => {
                            file_type: "json", body: "not really json"
                        }
                    }
    expect(gist.gist_files.to_a.count).to eq 2
  end
end
