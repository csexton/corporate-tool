require 'rails_helper'

RSpec.describe S3Url do
  it "parses path-style URLs" do
    expect(S3Url.parse("https://s3.amazonaws.com/corp.example.com/abc-1.png"))
      .to eq(["corp.example.com", "abc-1.png"])
  end

  it "parses regional path-style URLs" do
    expect(S3Url.parse("https://s3.us-east-2.amazonaws.com/bucket/dir/abc.png"))
      .to eq(["bucket", "dir/abc.png"])
  end

  it "parses virtual-hosted URLs" do
    expect(S3Url.parse("https://bucket.s3.amazonaws.com/abc.png")).to eq(["bucket", "abc.png"])
    expect(S3Url.parse("https://corp.example.com.s3.us-west-2.amazonaws.com/abc.png"))
      .to eq(["corp.example.com", "abc.png"])
  end

  it "unescapes the key" do
    expect(S3Url.parse("https://s3.amazonaws.com/bucket/a%20b.png")).to eq(["bucket", "a b.png"])
  end

  it "ignores other URLs" do
    expect(S3Url.parse("https://example.com/bucket/abc.png")).to be_nil
    expect(S3Url.parse("https://s3.amazonaws.com/bucket-only")).to be_nil
    expect(S3Url.parse(nil)).to be_nil
  end
end
