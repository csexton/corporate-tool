require 'rails_helper'

RSpec.describe Renderer, type: :model do
  let(:renderer) { Renderer.new }

  it "renders a title" do
    body = renderer.render_markdown("# Gallifrey")

    expect(body).to include("<h1 id=\"gallifrey\">Gallifrey</h1>")
  end

  it "renders a code span" do
    body = renderer.render_markdown("`tardis = Tardis.new`{:.language-ruby}")

    expect(body).to include("language-ruby highlighter-mermaid_rouge")
  end

  it "renders a mermaid div" do
    body = renderer.render_markdown <<~MARKDOWN
      ```mermaid
        graph TD
        A[Rose Tyler] --> B[Bad Wolf]
      ```
    MARKDOWN

    expect(body).to include("<div class=\"mermaid\">")
  end


  it "renders fenced codeblock" do
    body = renderer.render_markdown <<~MARKDOWN
      ``` ruby
        def regenerations_left?
          12
        end
      ```
    MARKDOWN

    # This checks for the coderay highlighting
    expect(body).to include("language-ruby")
  end

  it "renders tables" do
    body = renderer.render_markdown <<~MARKDOWN
      |-------------+-----------------------+--------------+-------|
      | Incarnation | Actor                 | Companion    | Debut |
      |-------------|:----------------------|:------------:|------:|
      | Ninth       | Christopher Eccleston | Rose Tyler   | 2005  |
      | Tenth       | David Tennant         | Martha Jones | 2005  |
      | Eleventh    | Matt Smith            | **Amy Pond** | 2010  |
      |-------------+-----------------------+--------------+-------|
      | Twelfth     | Peter Capaldi         | Clara Oswald | 2013  |
      | Thirteenth  | Jodie Whittaker       | Yasmin Khan  | 2017  |
      |=============+=======================+==============+=======|
      | Fourteenth  | David Tennant         | Donna Noble  | 2022  |
      |-------------+-----------------------+--------------+-------|
    MARKDOWN

    expect(body).to include("<th style=\"text-align:left;\">")
    expect(body).to include("<tfoot>")
    expect(body).to include("<thead>")
  end

  it "renders emoji" do
    body = renderer.render_markdown("Bow ties are cool :smile:")

    expect(body).to include("smile.png")
  end

  describe "sanitizing" do
    it "strips script tags and event handlers from raw HTML" do
      body = renderer.render_markdown(
        %(Hello, sweetie <img src="x" onerror="alert(1)"> <script>alert(2)</script>)
      )

      expect(body).not_to include("onerror")
      expect(body).not_to include("<script")
      expect(body).to include(%(<img src="x">))
    end

    it "strips javascript: links" do
      body = renderer.render_markdown("[Open the Pandorica](javascript:alert(1))")

      expect(body).not_to include("javascript:")
      expect(body).to include("Open the Pandorica")
    end

    it "escapes markup inside mermaid blocks" do
      body = renderer.render_markdown <<~MARKDOWN
        ```mermaid
        </div><script>alert(1)</script>
        graph TD
        TARDIS --> Vortex
        ```
      MARKDOWN

      expect(body).not_to include("<script")
      expect(body).to include("TARDIS --&gt; Vortex")
    end

    it "keeps task list checkboxes" do
      body = renderer.render_markdown("- [ ] Find Clara\n- [x] Save Gallifrey\n")

      expect(body).to include(%(<input type="checkbox" class="task-list-item-checkbox" disabled="disabled">))
      expect(body).to include(%(checked="checked"))
    end

    it "keeps heading ids, table alignment, and syntax highlighting" do
      body = renderer.render_markdown <<~MARKDOWN
        # Trenzalore

        | Planet |
        |:--|
        | Skaro |

        ```ruby
        :exterminate
        ```
      MARKDOWN

      expect(body).to include(%(<h1 id="trenzalore">))
      expect(body).to include(%(<td style="text-align:left;">))
      expect(body).to include(%(<span class="ss">:exterminate</span>))
    end
  end

  describe "links to uploads" do
    around do |example|
      bucket = ENV["S3_BUCKET"]
      ENV["S3_BUCKET"] = "black-archive.example.com"
      example.run
    ensure
      ENV["S3_BUCKET"] = bucket
    end

    let!(:upload) do
      Upload.create!(url: "https://s3.amazonaws.com/black-archive.example.com/sonic_screwdriver.png",
                     storage_key: "sonic_screwdriver.png", file_type: "image/png",
                     user: User.create!(name: "Rory Williams", uid: "1"))
    end

    it "points old S3 image and link URLs at the app" do
      body = renderer.render_markdown(<<~MARKDOWN)
        ![Sonic screwdriver](https://s3.amazonaws.com/black-archive.example.com/sonic_screwdriver.png)
        [Schematics](https://black-archive.example.com.s3.amazonaws.com/sonic_screwdriver.png)
      MARKDOWN

      expect(body).to include(%(src="/uploads/#{upload.id}/file"))
      expect(body).to include(%(href="/uploads/#{upload.id}/file"))
      expect(body).not_to include("amazonaws.com")
    end

    it "leaves other buckets, unknown keys and plain text alone" do
      body = renderer.render_markdown(<<~MARKDOWN)
        ![Torchwood's copy](https://s3.amazonaws.com/torchwood-three/sonic_screwdriver.png)
        ![Doctor who?](https://s3.amazonaws.com/black-archive.example.com/the_doctors_name.png)
        `https://s3.amazonaws.com/black-archive.example.com/sonic_screwdriver.png`
      MARKDOWN

      expect(body).to include("torchwood-three/sonic_screwdriver.png")
      expect(body).to include("black-archive.example.com/the_doctors_name.png")
      expect(body).to include("<code>https://s3.amazonaws.com/black-archive.example.com/sonic_screwdriver.png</code>")
    end
  end
end
