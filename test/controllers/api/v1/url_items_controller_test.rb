require 'rails_helper'

RSpec.describe Api::V1::UrlItemsController, type: :controller do
    render_views
    describe "index" do
        let!(:user_with_todo_items) { FactoryBot.create(:user_with_todo_items) }
        context "when authenticated" do
            it "displays the current users todo items" do
                sign_in user_with_todo_items
                get :index, format: :json
                expect(response.status).to eq(200)
                expect(JSON.parse(response.body)).to eq(JSON.parse(user_with_todo_items.todo_items.to_json))
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
        let!(:user_with_todo_items) { FactoryBot.create(:user_with_todo_items) }
        let!(:another_user_with_todo_items) { FactoryBot.create(:user_with_todo_items) }
        context "when authenticated" do
            it "returns a todo_item" do
                todo_item = user_with_todo_items.todo_items.first
                sign_in user_with_todo_items
                get :show, format: :json, params: { short_url: todo_item.short_url }
                expect(response.status).to eq(200)
                expect(JSON.parse(response.body)).to eq(JSON.parse(todo_item.to_json))
            end
            it "does not allow a user to view other's todo_items" do
                another_users_todo_item = another_user_with_todo_items.todo_items.first
                sign_in user_with_todo_items
                get :show, format: :json, params: { short_url: another_users_todo_item.short_url }
                expect(response.status).to eq(401)
            end
        end
        context "when not authenticated" do
            it "returns unauthorized" do
                todo_item = user_with_todo_items.todo_items.first
                get :show, format: :json, params: { short_url: todo_item.short_url }
                expect(response.status).to eq(401)
            end
        end
    end

    describe "create" do
        let!(:user_with_todo_items) { FactoryBot.create(:user_with_todo_items) }
        let!(:another_user_with_todo_items) { FactoryBot.create(:user_with_todo_items) }
        context "when authenticated" do
            it "returns a todo_item" do
                sign_in user_with_todo_items
                new_todo = { title: "a new todo", user: user_with_todo_items }
                post :create, format: :json, params: { todo_item: new_todo }
                expect(response.status).to eq(201)
                expect(JSON.parse(response.body)["title"]).to eq(new_todo[:title])
            end
            it "creates a todo_item" do
                sign_in user_with_todo_items
                new_todo = { title: "a new todo", user: user_with_todo_items }
                expect { post :create, format: :json, params: { todo_item: new_todo } }.to change{ UrlItem.count }.by(1)
            end
            it "returns a message if invalid" do
                sign_in user_with_todo_items
                invalid_new_todo = { title: "", user: user_with_todo_items }
                expect { post :create, format: :json, params: { todo_item: invalid_new_todo } }.to_not change{ UrlItem.count }
                expect(response.status).to eq(422)
            end
            it "does not allow a user to create other's todo_items" do
                sign_in user_with_todo_items
                new_todo = { title: "a new todo create by the wrong accout", user: another_user_with_todo_items }
                post :create, format: :json, params: { todo_item: new_todo }
                expect(JSON.parse(response.body)["user_id"]).to eq(user_with_todo_items.short_url)
                expect(JSON.parse(response.body)["user_id"]).to_not eq(another_user_with_todo_items.short_url)
            end
        end
        context "when not authenticated" do
            it "returns unauthorized" do
                new_todo = { title: "a new todo", user: user_with_todo_items }
                post :create, format: :json, params: { todo_item: new_todo }
                expect(response.status).to eq(401)
            end
        end
    end

    describe "destroy" do
        let!(:user_with_todo_items) { FactoryBot.create(:user_with_todo_items) }
        let!(:another_user_with_todo_items) { FactoryBot.create(:user_with_todo_items) }
        context "when authenticated" do
            it "returns no content" do
                sign_in user_with_todo_items
                destroyed_todo = user_with_todo_items.todo_items.first
                delete :destroy, format: :json, params: { short_url: destroyed_todo.short_url }
                expect(response.status).to eq(204)
            end
            it "destroys a todo_item" do
                sign_in user_with_todo_items
                destroyed_todo = user_with_todo_items.todo_items.first
                expect{ delete :destroy, format: :json, params: { short_url: destroyed_todo.short_url } }.to change{ UrlItem.count }.by(-1) 
            end
            it "does not allow a user to destroy other's todo_items" do
                sign_in user_with_todo_items
                another_users_destroyed_todo = another_user_with_todo_items.todo_items.first
                expect{ delete :destroy, format: :json, params: { short_url: another_users_destroyed_todo.short_url } }.to_not change{ UrlItem.count }
            end
        end
        context "when not authenticated" do
            it "returns unauthorized" do
                destroyed_todo = user_with_todo_items.todo_items.first
                delete :destroy, format: :json, params: { short_url: destroyed_todo.short_url }
                expect(response.status).to eq(401)
            end
        end
    end

end