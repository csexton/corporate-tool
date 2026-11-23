require 'rails_helper'

feature 'full text search' do
  let!(:amy) { User.create! name: "Amy Pond" }

  before do
    sign_in amy

    10.times do |i|
      Page.create! path: "numbered/page/#{i}", body: "Page #{i} body"
    end
  end

  scenario 'find pages with word in the body' do
    visit search_path
    fill_in "search_field", with: "body"
    click_button "Search"
    expect(find(".search-results")).to have_text("Page 1 body")
  end

  scenario 'shows HTML in page source as text' do
    Page.create! path: "html-docs", body: "```html\n<img src=x onerror=alert(1)> widget\n```\n"

    visit search_path(q: "widget")

    expect(page).to have_no_css(".search-results img")
    expect(find(".search-preview")).to have_text("<img src=x onerror=alert(1)> widget")
  end

  scenario 'find pages with word in the path' do
    visit search_path
    fill_in "search_field", with: "numbered/page/1"
    click_button "Search"
    expect(find(".search-results")).to have_text("numbered/page/1")
  end
end
