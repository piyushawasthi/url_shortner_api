module Api
	module V1
		class ShortsController < ApplicationController
			
			before_action :set_short, only: [:create]
			before_filter :restrict_access
  			skip_before_action :require_login
			respond_to :json

			def create(user, token, original_url)
				@short_url = ShortUrl.find_or_initialize_by(original_url: original_url)
			    @short_url[:user_id] = user.id
				shorten
				@short_url
			end

			def shorten
				@characters = ["a", "b", "c", "d", "e", "f", "g",
			                   "h", "i", "j", "k", "l", "m", "n",
			                   "o", "p", "q", "r", "s", "t", "u",
			                   "v", "w", "x", "y", "z", "A", "B",
			                   "C", "D", "E", "F", "G", "H", "I",
			                   "J", "K", "L", "M", "N", "O", "P",
			                   "Q", "R", "S", "T", "U", "V", "W",
			                   "X", "Y", "Z", "1", "2", "3", "4",
			                   "5", "6", "7", "8", "9", "0"]
			    path = ""
			    6.times { path << @characters[rand(61)] }
			    if ShortUrl.all.select { |l| l.shorty == path }.any?
			      @short_url.shorten
			    else
			      @short_url.shorty = path
			    end
			    @short_url
			end

		 private

		    # Use callbacks to share common setup or constraints between actions.
		    def set_short
		      @short_url = ShortUrl.find_or_initialize_by(original_url: original_url)
		      @short_url[:user_id] = user.id
			  shorten
		    end

		    # Never trust parameters from the scary internet, only allow the white list through.
		    def short_params
		      params.require(:short_url).permit(:original_url, :shorty, :user_id, :visits_count)
		    end

			def restrict_access
				User.where(:api_token => token).exists?
			end
		end
	end
end