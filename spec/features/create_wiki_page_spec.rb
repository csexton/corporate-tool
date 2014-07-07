require 'rails_helper'

feature 'create wiki pages' do

  let!(:amy) { User.create! name: "Amy Pond" }

  scenario 'create index page' do
    sign_in amy

    visit root_path
    click_link "add an index page"
    fill_in "page_body", with: "I am the index body"
    click_button "page_save"
    visit root_path

    expect(page).to have_content "I am the index body"
  end

  scenario 'create sidebar page' do
    sign_in amy

    visit root_path
    click_link "add a sidebar page"
    fill_in "page_body", with: "I am the sidebar body"
    click_button "page_save"
    visit root_path

    expect(page).to have_content "I am the sidebar body"
  end

end
