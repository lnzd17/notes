require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  describe 'notes#index action' do
    it 'returns successfully' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'notes#create action' do
    before(:each) do
      post :create, params: {note: {title: 'First', content: 'Hello'} }
    end

    it 'returns 200 status-code' do
      expect(response).to be_success
    end

    it 'saves a note to the database' do
      note = Note.last
      expect(note.title).to eq('First')
      expect(note.content).to eq('Hello')
    end

    it 'returns the note in response body' do
      json = JSON.parse(response.body)
      expect(json['title']).to eq('First')
      expect(json['content']).to eq('Hello')
    end
  end
end
