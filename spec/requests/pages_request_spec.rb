require 'rails_helper'

RSpec.describe "Pages", :type => :request do
  describe "GET /pages" do
    it "redirects when unauthenticated" do
      get pages_path
      expect(response.status).to be(302)
    end
  end

  let(:rory) {User.create!(name: 'Rory', uid: "1")}
  let(:valid_attributes) { { path: 'path/to/page', body: 'I am **content**' } }
  let(:invalid_attributes) { { path: 'bad_page', body: nil} }
  let(:valid_session) { { user_id: rory.id} }

  describe "GET index" do
    it "assigns all pages as @pages" do
      sign_in rory
      page = Page.create! valid_attributes
      get pages_path
      expect(response.body).to include("All Wiki Pages")
    end
  end

  describe "GET show" do
    it "assigns the requested page as @page" do
      sign_in rory
      page = Page.create! valid_attributes
      get page_path(page)
      expect(response.body).to include("I am")
    end
  end

  describe "GET new" do
    it "assigns a new page as @page" do
      sign_in rory
      get new_page_path
      expect(response.body).to include("Path to the page")
    end
  end

  describe "GET edit" do
    it "assigns the requested page as @page" do
      sign_in rory
      page = Page.create! valid_attributes
      get edit_page_path(page)
      expect(response.body).to include("Path to the page")
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Page" do
        sign_in rory
        expect {
          post pages_path, params: {page: valid_attributes}
        }.to change(Page, :count).by(1)
      end

      it "redirects to the created page" do
        sign_in rory
        post pages_path, params: {page: valid_attributes}
        expect(response).to redirect_to("/#{Page.last.path}")
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved page as @page" do
        sign_in rory
        post pages_path, params: {page: invalid_attributes}
        expect(response.body).to include("Body can&#39;t be blank")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) { {path: 'new/path'} }

      it "updates the requested page" do
        sign_in rory
        page = Page.create! valid_attributes
        put page_path(page), params: {page: new_attributes}
        page.reload
        expect(page.path).to eq('new/path')
      end

      it "redirects to the page" do
        sign_in rory
        page = Page.create! valid_attributes
        put page_path(page), params: {page: new_attributes}
        page.reload
        expect(response).to redirect_to("/#{new_attributes[:path]}")
      end
    end

    describe "with invalid params" do
      it "assigns the page as @page" do
        sign_in rory
        page = Page.create! valid_attributes
        put page_path(page), params: {page: invalid_attributes}
        expect(response.body).to include("Body can&#39;t be blank")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested page" do
      sign_in rory
      page = Page.create! valid_attributes
      expect {
        delete page_path(page)
      }.to change(Page, :count).by(-1)
    end

    it "redirects to the pages list" do
      sign_in rory
      page = Page.create! valid_attributes
      delete page_path(page)
      expect(response).to redirect_to(pages_url)
    end
  end

end
