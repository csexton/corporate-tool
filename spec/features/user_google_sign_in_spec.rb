require 'rails_helper'

feature 'Sign in via Google' do
  let!(:user) { User.create(name: "Amy Pond", uid: 1) }

  scenario 'click login via facebook' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google] = {
        'provider' => 'google',
        'uid' => "1",
        'info'  => {
          'name' => 'Amy Pond',
          'email' => 'amy@tardis.org'
        },
        'extra' => {
          'raw_info' => {
            'hd' => ENV['GOOGLE_HOME_DOMAIN']
          }
        }
    }


    visit root_path
    click_link 'Login with Google Apps'
    expect(find('header')).to have_content('Signed in as Amy Pond')
  end

end
