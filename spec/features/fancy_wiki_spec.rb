require 'rails_helper'

feature 'wiki does fancy things' do

  let!(:amy) { User.create! name: "Amy Pond" }

  scenario 'displays emoji' do
    sign_in amy
    visit new_page_path

    fill_in "page_path", with: "fancy"
    fill_in "page_body", with: ":smile:"
    click_button "page_save"

    expect(page).to have_xpath("//img[@src=\"/images/emoji/smile.png\"]")
  end

  scenario 'syntax highlights ruby code' do
    sign_in amy
    visit new_page_path

    fill_in "page_path", with: "fancy"
    fill_in "page_body", with: <<-EOF.strip_heredoc
      ``` ruby
      def method
        :symbol
      end
      ```
    EOF
    click_button "page_save"

    # Check for the classes that pygments adds to the code
    expect(find('pre .ss')).to have_content("symbol")
    expect(find('pre .nf')).to have_content("method")
  end

end
