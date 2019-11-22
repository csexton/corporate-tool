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

  scenario 'find pages with word in the path' do
    visit search_path
    fill_in "search_field", with: "numbered/page/1"
    click_button "Search"
    expect(find(".search-results")).to have_text("numbered/page/1")
  end
end
