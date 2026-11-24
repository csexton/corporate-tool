require 'rails_helper'

feature 'create wiki pages' do

  let!(:amy) { User.create! name: "Amy Pond" }

  scenario 'create index page' do
    sign_in amy

    visit root_path
    click_link "add an index page"
    fill_in "page_body", with: "Bigger on the inside."
    click_button "page_save"
    visit root_path

    expect(page).to have_content "Bigger on the inside."
  end

  scenario 'create sidebar page' do
    sign_in amy

    visit root_path
    click_link "add a sidebar page"
    fill_in "page_body", with: "Allons-y!"
    click_button "page_save"
    visit root_path

    expect(page).to have_content "Allons-y!"
  end

end
