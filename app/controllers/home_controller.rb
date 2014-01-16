class HomeController < ApplicationController


	def index
		@user_address = user_address
		@agency_list = getRouteListForAgency();
	end

	def show
		@user_address = user_address
		@stops_for_route = GetStopsForRoute(params[:code],params[:direction])
	end

	def stop_detail
		times_for_stops = GetNextDeparturesByStopName(params[:stopName])
		respond_to do |format|
	      format.html # index.html.erb
	      format.json { render json: times_for_stops.to_json, :status => 200 }
	    end
	end


	#Return address string
	#Example: 1885 Page St, San Francisco, CA 94117
	#Input: lat, lng
	#If no input method defaults to current request location information
	def user_address(lat=0,lng=0)
		if (lat==0 || lng==0) && (request.location.latitude != 0 && request.location.longitude != 0)
			lat = request.location.latitude
			lng = request.location.longitude
		else
			lat = 37.7691
			lng = -122.4449
		end
		Geocoder.address([lat, lng])
	end

	def getRouteListForAgency(agencyName='SF-MUNI')
		uri = URI.parse(MUNI_BASE_URL)
		req = Net::HTTP::Get.new("/Transit2.0/GetRoutesForAgency.aspx?token=#{MUNI_API_KEY}&agencyName=#{agencyName}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.start do |http| 
		  http.request(req)
		end
		Hash.from_xml(response.body)
	end

	def GetStopsForRoute(route_code,route_direction,agencyName='SF-MUNI')
		uri = URI.parse(MUNI_BASE_URL)
		req = Net::HTTP::Get.new("/Transit2.0/GetStopsForRoute.aspx?token=#{MUNI_API_KEY}&routeIDF=#{agencyName}~#{route_code}~#{route_direction}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.start do |http| 
		  http.request(req)
		end
		Hash.from_xml(response.body)
	end

	def GetNextDeparturesByStopName(stopName,agencyName='SF-MUNI')
 		distance_between = Geocoder::Calculations.distance_between(Geocoder.coordinates("#{stopName} San Francisco"),[request.location.latitude,request.location.longitude])
		uri = URI.parse(MUNI_BASE_URL)
		req = Net::HTTP::Get.new(URI::escape("/Transit2.0/GetNextDeparturesByStopName.aspx?token=#{MUNI_API_KEY}&agencyName=#{agencyName}&stopName=#{stopName}"))
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.start do |http| 
		  http.request(req)
		end
		hash = Hash.from_xml(response.body)
		hash[:distance_between] = "#{distance_between.to_f.round(3)} miles away"
		hash
	end
end
