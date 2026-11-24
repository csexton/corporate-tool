require 'rails_helper'

RSpec.describe SearchHelper, type: :helper do
  describe "#highlight_match" do
    it "wraps each match in strong" do
      expect(helper.highlight_match("Exterminate! Exterminate!", "Exterminate"))
        .to eq("<strong>Exterminate</strong>! <strong>Exterminate</strong>!")
    end

    it "escapes HTML in the line and the query" do
      html = helper.highlight_match(%(<img src=x onerror=alert(1)> <b>), "<b>")

      expect(html).to eq("&lt;img src=x onerror=alert(1)&gt; <strong>&lt;b&gt;</strong>")
      expect(html).to be_html_safe
    end
  end
end
