class UrlsController < ApplicationController
    def index
      @url = Url.new
    end

    def show
      @url = Url.find_by_short_url(params[:short_url])
      not_found and return if @url.nil?

      redirect_to @url.sanitized_url
    end

    def create
      return if url_params[:url].nil?

      @url = Url.new(url_params)
      @url.sanitize

      redirect_to shortened_path(@url.short_url_admin) and return if @url.save

      flash[:error] = "Check the error below:"
      render 'index'
    end

    def shortened
      # Remove last +
      @url = Url.find_by_short_url(params[:short_url][0...-1])
      not_found and return if @url.nil?

      render 'shortened'
    end

    private

    def url_params
      params.require(:url).permit(:url)
    end
  end
