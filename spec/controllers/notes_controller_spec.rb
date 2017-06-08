require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  describe 'notes#index action' do
    it 'returns successfully' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns all notes in ascending order' do
      2.times do
        FactoryGirl.create(:note)
      end
      get :index
      json = JSON.parse(response.body)
      expect(json[0]['id'] < json[1]['id']).to be true
    end
  end

  describe 'notes#create action' do
    before do
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

  describe 'notes#create action validation' do
    before do
      post :create, params: {note: {title: '', content: ''} }
    end

    it 'properly handle validation errors' do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns json error on validation error' do
      json = JSON.parse(response.body)
      expect(json['errors']['title'][0]).to eq("can't be blank")
      expect(json['errors']['content'][0]).to eq("can't be blank")
    end

  end

  describe 'note#show action' do
    it 'return a note' do
      note = FactoryGirl.create(:note)
      get :show, params: { id: note.id }
      json = JSON.parse(response.body)
      expect(json['id']).to eq(note.id)
    end
  end

  describe 'note#update action' do
    before do
      @note = FactoryGirl.create(:note)
    end

    it 'returns the updated note response' do
      put :update, params: { id: @note.id, note: { title: 'Updated First', content: 'Updated this note.'} }
      json = JSON.parse(response.body)
      expect(json['title']).to eq('Updated First')
      expect(json['content']).to eq('Updated this note.')
      expect(response).to be_success
    end

    it 'deals with validation errors' do
      put :update, params: { id: @note.id, note: { title: '', content: ''} }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns json error on validation error' do
      put :update, params: { id: @note.id, note: { title: '', content: ''} }
      json = JSON.parse(response.body)
      expect(json['errors']['title'][0]).to eq("can't be blank")
      expect(json['errors']['content'][0]).to eq("can't be blank")
    end
  end

  describe 'note#destroy action' do
    before do
      @note = FactoryGirl.create(:note)
      delete :destroy, params: { id: @note.id }
    end

    it 'destroys a note' do
      note = Note.find_by_id(@note.id)
      expect(note).to eq(nil)
    end

    it 'returns a no_content error' do
      expect(response).to have_http_status(:no_content)
    end
  end
end
