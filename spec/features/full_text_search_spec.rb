require 'rails_helper'

feature 'full text search' do
  let!(:amy) { User.create! name: "Amy Pond" }

  before do
    sign_in amy

    10.times do |i|
      Page.create! path: "regenerations/#{i}", body: "Regeneration #{i} of the Doctor"
    end
  end

  scenario 'find pages with word in the body' do
    visit search_path
    fill_in "search_field", with: "regeneration"
    click_button "Search"
    expect(find(".search-results")).to have_text("Regeneration 1 of the Doctor")
  end

  scenario 'shows HTML in page source as text' do
    Page.create! path: "cybermen/upgrade-notes", body: "```html\n<img src=x onerror=alert(1)> Delete. Delete.\n```\n"

    visit search_path(q: "Delete")

    expect(page).to have_no_css(".search-results img")
    expect(find(".search-preview")).to have_text("<img src=x onerror=alert(1)> Delete. Delete.")
  end

  scenario 'find pages with word in the path' do
    visit search_path
    fill_in "search_field", with: "regenerations/1"
    click_button "Search"
    expect(find(".search-results")).to have_text("regenerations/1")
  end
end
