require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  describe 'tags#create action' do
    before do
      @note = FactoryGirl.create(:note)
      post :create, params: { tag: { name: 'Crazy' }, note_id: @note.id }
    end
    
    it 'returns a 200 status code' do
      expect(response).to be_success
    end

    it 'succesfully creates and saves a tag in the DB' do
      expect(@note.tags.first.name).to eq('Crazy')
    end
  end

end
