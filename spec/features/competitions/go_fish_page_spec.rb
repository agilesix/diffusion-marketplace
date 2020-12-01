require 'rails_helper'

describe 'Go Fish landing page', type: :feature do
  it 'should redirect the user to the homepage' do
    visit '/competitions/go-fish'
    expect(page).to_not have_content('Go Fish')
    expect(page).to have_content('Welcome to the Diffusion Marketplace')
  end
end