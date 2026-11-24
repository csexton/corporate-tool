require 'rails_helper'

RSpec.describe S3Url do
  it "parses path-style URLs" do
    expect(S3Url.parse("https://s3.amazonaws.com/black-archive.example.com/sonic_screwdriver.png"))
      .to eq(["black-archive.example.com", "sonic_screwdriver.png"])
  end

  it "parses regional path-style URLs" do
    expect(S3Url.parse("https://s3.us-east-2.amazonaws.com/torchwood-three/vault/missy.png"))
      .to eq(["torchwood-three", "vault/missy.png"])
  end

  it "parses virtual-hosted URLs" do
    expect(S3Url.parse("https://torchwood-three.s3.amazonaws.com/rift_manipulator.png"))
      .to eq(["torchwood-three", "rift_manipulator.png"])
    expect(S3Url.parse("https://black-archive.example.com.s3.us-west-2.amazonaws.com/sonic_screwdriver.png"))
      .to eq(["black-archive.example.com", "sonic_screwdriver.png"])
  end

  it "unescapes the key" do
    expect(S3Url.parse("https://s3.amazonaws.com/torchwood-three/bad%20wolf.png"))
      .to eq(["torchwood-three", "bad wolf.png"])
  end

  it "ignores other URLs" do
    expect(S3Url.parse("https://example.com/black-archive/sonic_screwdriver.png")).to be_nil
    expect(S3Url.parse("https://s3.amazonaws.com/black-archive")).to be_nil
    expect(S3Url.parse(nil)).to be_nil
  end
end
