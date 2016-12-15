class ShortUrlsController < ApplicationController
  include SessionsHelper
 
  before_filter :require_login
  skip_before_filter  :verify_authenticity_token
  before_action :set_short_url, only: [:show, :short_visits, :destroy]
  before_action :create_short_url, only: [:create]

  def index
    respond_to do |format|
      format.html 
      format.json { render json: SortUrlsDatatable.new(view_context, current_user.id) }
    end
  end

  def show
  end

  def new
    @short_url = ShortUrl.new
  end

  def short_visits
    @short_visits = @short_url.short_visits
  end

  def create
    respond_to do |format|
      if @short_url.save
        format.html { redirect_to @short_url, notice: 'Short url was successfully created.' }
        format.json { render :show, status: :created, location: @short_url }
      else
        format.html { render :new }
        format.json { render json: @short_url.errors, status: :unprocessable_entity }
      end
    end
  end

  def redirect
    short_url = ShortUrl.find_by(shorty: params[:shorty])
    if short_url
      short_url.create_short_visit
      short_url.calculate_visits_count
      redirect_to "http://#{short_url.original_url}"
    else
      render :new
    end
  end

  def destroy
    @short_url.destroy
    respond_to do |format|
      format.html { redirect_to short_urls_url, notice: 'Short url was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    def set_short_url
      @short_url = ShortUrl.find(params[:id])
    end

    def create_short_url
      @short_url = Api::V1::ShortsController.new.create(current_user, current_user.api_token, short_url_params[:original_url])
    end

    def short_url_params
      params.require(:short_url).permit(:original_url, :shorty, :user_id, :visits_count)
    end
end
