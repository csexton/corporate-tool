require 'rails_helper'

feature 'wiki does fancy things' do

  let!(:amy) { User.create! name: "Amy Pond" }

  scenario 'displays emoji' do
    sign_in amy
    visit new_page_path

    fill_in "page_path", with: "gallifrey"
    fill_in "page_body", with: ":smile:"
    click_button "page_save"

    expect(page).to have_xpath("//img[@src=\"/images/emoji/smile.png\"]")
  end

  scenario 'syntax highlights ruby code' do
    sign_in amy
    visit new_page_path

    fill_in "page_path", with: "regeneration"
    fill_in "page_body", with: <<-EOF.strip_heredoc
      ``` ruby
      def regenerate
        :new_face
      end
      ```
    EOF
    click_button "page_save"

    # Check for the classes that pygments adds to the code
    expect(find('pre .ss')).to have_content("new_face")
    expect(find('pre .nf')).to have_content("regenerate")
  end

end
