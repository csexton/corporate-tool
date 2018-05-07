require 'rails_helper'

RSpec.describe Renderer, type: :model do
  let(:renderer) { Renderer.new }

  it "renders a title" do
    body = renderer.render_markdown("# title")

    expect(body).to include("<h1 id=\"title\">title</h1>")
  end

  it "renders a code span" do
    body = renderer.render_markdown("`x = Class.new`{:.language-ruby}")

    expect(body).to include("language-ruby highlighter-rouge")
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

    expect(body).to include("<th style=\"text-align: left\">")
    expect(body).to include("<tfoot>")
    expect(body).to include("<thead>")
  end

  it "renders emoji" do
    body = renderer.render_markdown("This is :smile:")

    expect(body).to include("smile.png")
  end
end
