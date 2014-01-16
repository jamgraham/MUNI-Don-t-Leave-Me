class MuniController < ApplicationController


	def index

		agencyList = getRouteListForAgency()

		respond_to do |format|
	      format.html # index.html.erb
	      format.json { render json: agencyList.to_json, :status => 200 }
	    end
	end



end
