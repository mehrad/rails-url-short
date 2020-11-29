require 'rails_helper'

RSpec.describe Api::V1::UrlItemsController, type: :controller do
    render_views
    describe "index" do
        let!(:user_with_url_items) { FactoryBot.create(:user_with_url_items) }
        context "when authenticated" do
            it "displays the current users url items" do
                sign_in user_with_url_items
                get :index, format: :json
                expect(response.status).to eq(200)
                expect(JSON.parse(response.body)).to eq(JSON.parse(user_with_url_items.url_items.to_json))
            end
        end
        context "when not authenticated" do
            it "returns unauthorized" do
                get :index, format: :json
                expect(response.status).to eq(401)
            end
        end
    end

    describe "show" do
        let!(:user_with_url_items) { FactoryBot.create(:user_with_url_items) }
        let!(:another_user_with_url_items) { FactoryBot.create(:user_with_url_items) }
        context "when authenticated" do
            it "returns a url_item" do
                url_item = user_with_url_items.url_items.first
                sign_in user_with_url_items
                get :show, format: :json, params: { short_url: url_item.short_url }
                expect(response.status).to eq(200)
                expect(JSON.parse(response.body)).to eq(JSON.parse(url_item.to_json))
            end
            it "does not allow a user to view other's url_items" do
                another_users_url_item = another_user_with_url_items.url_items.first
                sign_in user_with_url_items
                get :show, format: :json, params: { short_url: another_users_url_item.short_url }
                expect(response.status).to eq(401)
            end
        end
        context "when not authenticated" do
            it "returns unauthorized" do
                url_item = user_with_url_items.url_items.first
                get :show, format: :json, params: { short_url: url_item.short_url }
                expect(response.status).to eq(401)
            end
        end
    end

    describe "create" do
        let!(:user_with_url_items) { FactoryBot.create(:user_with_url_items) }
        let!(:another_user_with_url_items) { FactoryBot.create(:user_with_url_items) }
        context "when authenticated" do
            it "returns a url_item" do
                sign_in user_with_url_items
                new_url = { title: "a new url", user: user_with_url_items }
                post :create, format: :json, params: { url_item: new_url }
                expect(response.status).to eq(201)
                expect(JSON.parse(response.body)["title"]).to eq(new_url[:title])
            end
            it "creates a url_item" do
                sign_in user_with_url_items
                new_url = { title: "a new url", user: user_with_url_items }
                expect { post :create, format: :json, params: { url_item: new_url } }.to change{ UrlItem.count }.by(1)
            end
            it "returns a message if invalid" do
                sign_in user_with_url_items
                invalid_new_url = { title: "", user: user_with_url_items }
                expect { post :create, format: :json, params: { url_item: invalid_new_url } }.to_not change{ UrlItem.count }
                expect(response.status).to eq(422)
            end
            it "does not allow a user to create other's url_items" do
                sign_in user_with_url_items
                new_url = { title: "a new url create by the wrong accout", user: another_user_with_url_items }
                post :create, format: :json, params: { url_item: new_url }
                expect(JSON.parse(response.body)["user_id"]).to eq(user_with_url_items.short_url)
                expect(JSON.parse(response.body)["user_id"]).to_not eq(another_user_with_url_items.short_url)
            end
        end
        context "when not authenticated" do
            it "returns unauthorized" do
                new_url = { title: "a new url", user: user_with_url_items }
                post :create, format: :json, params: { url_item: new_url }
                expect(response.status).to eq(401)
            end
        end
    end

    describe "destroy" do
        let!(:user_with_url_items) { FactoryBot.create(:user_with_url_items) }
        let!(:another_user_with_url_items) { FactoryBot.create(:user_with_url_items) }
        context "when authenticated" do
            it "returns no content" do
                sign_in user_with_url_items
                destroyed_url = user_with_url_items.url_items.first
                delete :destroy, format: :json, params: { short_url: destroyed_url.short_url }
                expect(response.status).to eq(204)
            end
            it "destroys a url_item" do
                sign_in user_with_url_items
                destroyed_url = user_with_url_items.url_items.first
                expect{ delete :destroy, format: :json, params: { short_url: destroyed_url.short_url } }.to change{ UrlItem.count }.by(-1) 
            end
            it "does not allow a user to destroy other's url_items" do
                sign_in user_with_url_items
                another_users_destroyed_url = another_user_with_url_items.url_items.first
                expect{ delete :destroy, format: :json, params: { short_url: another_users_destroyed_url.short_url } }.to_not change{ UrlItem.count }
            end
        end
        context "when not authenticated" do
            it "returns unauthorized" do
                destroyed_url = user_with_url_items.url_items.first
                delete :destroy, format: :json, params: { short_url: destroyed_url.short_url }
                expect(response.status).to eq(401)
            end
        end
    end

end