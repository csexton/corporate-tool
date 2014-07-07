require 'rails_helper'

feature 'create gist' do

  let!(:amy) { User.create! name: "Amy Pond" }

  scenario 'create new gist' do
    sign_in amy

    visit root_path
    click_link "New Gist"
    fill_in "gist_description", with: "I am the gist description"
    select 'ruby', :from => 'gist_gist_files_attributes_0_file_type'
    fill_in "gist_gist_files_attributes_0_body", with: "puts :yo"
    click_button "gist_save"
    expect(page).to have_content "puts :yo"
  end
end
