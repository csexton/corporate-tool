require 'rails_helper'

RSpec.describe Renderer, type: :model do
  let(:renderer) { Renderer.new }

  it "renders a title" do
    body = renderer.render_markdown("# title")

    expect(body).to include("<h1 id=\"title\">title</h1>")
  end

  it "renders a code span" do
    body = renderer.render_markdown("`x = Class.new`{:.language-ruby}")

    expect(body).to include("language-ruby highlighter-mermaid_rouge")
  end

  it "renders a mermaid div" do
    body = renderer.render_markdown <<~MARKDOWN
      ```mermaid
        graph TD
        A[Markdown] --> B[Mermaid Graph]
      ```
    MARKDOWN

    expect(body).to include("<div class=\"mermaid\">")
  end


  it "renders fenced codeblock" do
    body = renderer.render_markdown <<~MARKDOWN
      ``` ruby
        def what?
          42
        end
      ```
    MARKDOWN

    # This checks for the coderay highlighting
    expect(body).to include("language-ruby")
  end

  it "renders tables" do
    body = renderer.render_markdown <<~MARKDOWN
      |-----------------+------------+-----------------+----------------|
      | Default aligned |Left aligned| Center aligned  | Right aligned  |
      |-----------------|:-----------|:---------------:|---------------:|
      | First body part |Second cell | Third cell      | fourth cell    |
      | Second line     |foo         | **strong**      | baz            |
      | Third line      |quux        | baz             | bar            |
      |-----------------+------------+-----------------+----------------|
      | Second body     |            |                 |                |
      | 2 line          |            |                 |                |
      |=================+============+=================+================|
      | Footer row      |            |                 |                |
      |-----------------+------------+-----------------+----------------|
    MARKDOWN

    expect(body).to include("<th style=\"text-align:left;\">")
    expect(body).to include("<tfoot>")
    expect(body).to include("<thead>")
  end

  it "renders emoji" do
    body = renderer.render_markdown("This is :smile:")

    expect(body).to include("smile.png")
  end

  describe "sanitizing" do
    it "strips script tags and event handlers from raw HTML" do
      body = renderer.render_markdown(
        %(hi <img src="x" onerror="alert(1)"> <script>alert(2)</script>)
      )

      expect(body).not_to include("onerror")
      expect(body).not_to include("<script")
      expect(body).to include(%(<img src="x">))
    end

    it "strips javascript: links" do
      body = renderer.render_markdown("[click](javascript:alert(1))")

      expect(body).not_to include("javascript:")
      expect(body).to include("click")
    end

    it "escapes markup inside mermaid blocks" do
      body = renderer.render_markdown <<~MARKDOWN
        ```mermaid
        </div><script>alert(1)</script>
        graph TD
        A --> B
        ```
      MARKDOWN

      expect(body).not_to include("<script")
      expect(body).to include("A --&gt; B")
    end

    it "keeps task list checkboxes" do
      body = renderer.render_markdown("- [ ] todo\n- [x] done\n")

      expect(body).to include(%(<input type="checkbox" class="task-list-item-checkbox" disabled="disabled">))
      expect(body).to include(%(checked="checked"))
    end

    it "keeps heading ids, table alignment, and syntax highlighting" do
      body = renderer.render_markdown <<~MARKDOWN
        # Title

        | a |
        |:--|
        | 1 |

        ```ruby
        :sym
        ```
      MARKDOWN

      expect(body).to include(%(<h1 id="title">))
      expect(body).to include(%(<td style="text-align:left;">))
      expect(body).to include(%(<span class="ss">:sym</span>))
    end
  end
end
