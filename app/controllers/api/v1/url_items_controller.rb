class Api::V1::UrlItemsController < ApplicationController
    before_action :set_url_item, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!

    def index
        @url_items = current_user.urls.page params[:page]
    end

    def new
        @url = Url.new
    end

    def create
        @url_item = current_user.urls.build(url_item_params)
        @url_item.set_short_url
        @url_item.sanitize

        if authorized?
          respond_to do |format|
            if @url_item.save
              format.json { render :show, status: :created, location: api_v1_url_item_path(@url_item) }
            else
              format.json { render json: @url_item.errors, status: :unprocessable_entity }
            end
          end
        else
          handle_unauthorized
        end
    end

    def update
        if authorized?
            respond_to do |format|
              if @url_item.update(url_item_params)
                format.json { render :show, status: :ok, location: api_v1_url_item_path(@url_item) }
              else
                format.json { render json: @url_item.errors, status: :unprocessable_entity }
              end
            end
        else
            handle_unauthorized
        end
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

    def destroy
        if authorized?
            @url_item.destroy
            respond_to do |format|
              format.json { head :no_content }
            end
        else
            handle_unauthorized
        end
    end

    private

    def url_item_params
        params.require(:url_item).permit(
            :url,
            :short_url
        )
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
