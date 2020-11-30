require 'rails_helper'

describe 'Page Groups', type: :feature do
  before do
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(:admin)
  end

  it 'Should allow the user to create a page group' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'
    click_link 'Page Groups'
    click_link 'New Page Group'
    fill_in('page_group_name', with: 'test')
    fill_in('page_group_description', with: 'test description')
    find('input[name="commit"]').click

    expect(page).to have_content('Page group was successfully created.')
    expect(page).to have_content('test')
    expect(page).to have_content('test description')
  end
end