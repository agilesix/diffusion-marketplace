require 'rails_helper'

describe 'Shark Tank landing page', type: :feature do
  it 'should redirect the user to the homepage' do
    visit '/competitions/shark-tank'
    expect(page).to_not have_content('Shark Tank')
    expect(page).to have_content('Welcome to the Diffusion Marketplace')
  end
end