class UrlsController < ApplicationController

    def new
      @url = Url.new
    end

    def my_url
      @urls = current_user.urls.page params[:page]
      @new_url = Url.new
      render 'my_url'
    end

    def show
      @url = Url.find_by_short_url(params[:short_url])
      not_found and return if @url.nil?

      # TODO(Mahrad): Add this line to sidekiq
      @url.add_click_count!
      redirect_to @url.sanitized_url
    end

    def create
      return if url_params[:url].nil?

      @url = Url.new(url_params)
      @url.sanitize

      if @url.save
        redirect_to shortened_path(@url.short_url_admin)
        return
      end

      flash[:error] = "Check the error below: #{@url.errors.messages}"
      render 'new'
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
