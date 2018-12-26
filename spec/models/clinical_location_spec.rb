require 'rails_helper'

RSpec.describe ClinicalLocation, type: :model do
  describe 'associations' do
    it { should have_many(:practices) }
  end
end
