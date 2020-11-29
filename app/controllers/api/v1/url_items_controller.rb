class Api::V1::UrlItemsController < ApplicationController
    before_action :set_url_item, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!

    def index
        @url_items = current_user.urls.page params[:page]
    end

    def show
        if authorized?
            respond_to do |format|
              format.json { render :show }
            end
        else
            handle_unauthorized
        end
    end

    private

    def url_params
        params.require(:url).permit(:url)
    end

    def set_url_item
        @url_item = Url.find_by_short_url(params[:short_url])
    end

    def authorized?
        @url_item.user == current_user
    end

    def handle_unauthorized
        unless authorized?
          respond_to do |format|
            format.json { render :unauthorized, status: 401 }
          end
        end
    end
end
