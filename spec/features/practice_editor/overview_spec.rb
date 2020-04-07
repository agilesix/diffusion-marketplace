require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', number_adopted: 1, date_initiated: Date.new(2011, 12, 31))
        @practice_partner = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative', icon: 'fas fa-heart', color: '#E4A002')
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'Overview page' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_overview_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            @save_button = find('#practice-editor-save-button')
            @image_path = File.join(Rails.root, '/spec/assets/charmander.png')
        end

        it 'should be there' do
            expect(page).to have_content('Overview')
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/instructions")
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/origin")
            expect(page).to have_field('Month', with: '12')
            expect(page).to have_field('Year', with: '2011')
            expect(page).to have_no_css("img[src*='charmander.png']")
            expect(page).to have_content('Upload photo')
            expect(page).to have_content('Upload a clear photo that will be shown as the representative image for this practice.')
            expect(page).to have_no_content('Upload new photo')
            expect(page).to have_no_content('Remove photo')
            expect(page).to have_no_content('Edit photo')
            expect(page).to have_no_content('Save edits')
            expect(page).to have_no_content('Cancel edits')
        end

        it 'should not have a link to the collaborators page' do
            expect(page).not_to have_link(href: "/practices/#{@practice.slug}/edit/collaborators")
        end

        it 'should allow the user to update the data on the page' do
            fill_in('practice_name', with: 'A super practice')
            fill_in('practice_tagline', with: 'Super duper')
            select('Alabama', :from => 'editor_state_select')
            select('Birmingham VA Medical Center', :from => 'editor_facility_select')
            select('October', :from => 'editor_date_intiated_month')
            select('1970', :from => 'editor_date_intiated_year')
            fill_in('practice_summary', with: 'This is the most super practice ever made')
            find('#practice_partner_1_label').click
            attach_file('Upload photo', @image_path)
            @save_button.click
            expect(page).to have_field('practice_name', with: 'A super practice')
            expect(page).to have_field('practice_tagline', with: 'Super duper')
            expect(page).to have_field('practice_summary', with: 'This is the most super practice ever made')
            expect(page).to have_field('Month', with: '10')
            expect(page).to have_field('Year', with: '1970')
            expect(page).to have_css("img[src*='charmander.png']")
            expect(page).to have_content('Remove photo')
            expect(page).to have_content('Upload new photo')
            expect(page).to have_content('Remove photo')
            expect(page).to have_content('Edit photo')
            expect(page).to have_no_content('Upload photo')
            expect(page).to have_no_content('Cancel edits')
            expect(page).to have_no_content('Save edits')
        end

        it 'should allow the user to edit the practice thumbnail' do
            attach_file('Upload photo', @image_path)
            @edit_button = find('.cropper-edit-mode')
            @edit_button.click
            expect(page).to have_no_content('Upload a clear photo that will be shown as the representative image for this practice.')
            expect(page).to have_content("Please click \"Save edits\" and then \"Save your progress\" to save and exit editor.")
            expect(page).to have_content('Cancel edits')
            expect(page).to have_content('Save edits')
            expect(page).to have_css('.cropper-modal')
            @save_edits_button = find('.cropper-save-edit')
            @save_edits_button.click
            expect(find("#crop_x", :visible => false).value).to match '23'
            expect(find("#crop_y", :visible => false).value).to match '23'
            expect(find("#crop_w", :visible => false).value).to match '180'
            expect(find("#crop_h", :visible => false).value).to match '180'
            @cancel_edits_button = find('.cropper-cancel-edit')
            @cancel_edits_button.click
            expect(find("#crop_x", :visible => false).value).to match ''
            expect(find("#crop_y", :visible => false).value).to match ''
            expect(find("#crop_w", :visible => false).value).to match ''
            expect(find("#crop_h", :visible => false).value).to match ''
        end

        # it 'should show an alert window if no practice partners were chosen' do
        #     select('Alabama', :from => 'editor_state_select')
        #     select('Birmingham VA Medical Center', :from => 'editor_facility_select')
        #     fill_in('practice_summary', with: 'This is the most super practice ever made')
        #     @save_button.click
        #     expect(accept_alert).to eq('Please choose at least one of the partners listed')
        # end

        # it 'should require the user to fill out the fields that are marked as required' do
        #     find('#practice_partner_1_label').click
        #     fill_in('practice_name', with: nil)
        #     @save_button.click
        #     name_message = page.find("#practice_name").native.attribute("validationMessage")
        #     expect(name_message).to eq('Please fill out this field.')
        #     fill_in('practice_name', with: 'A public practice')
        #     @save_button.click
        #     state_message = page.find("#editor_state_select").native.attribute("validationMessage")
        #     expect(state_message).to eq('Please select an item in the list.')
        #     select('Alabama', :from => 'editor_state_select')
        #     select('Birmingham VA Medical Center', :from => 'editor_facility_select')
        #     @save_button.click
        #     summary_message = page.find("#practice_summary").native.attribute("validationMessage")
        #     expect(summary_message).to eq('Please fill out this field.')
        # end
    end
end