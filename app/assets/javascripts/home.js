var home = {

  /**
   * 
   * @author jgraham
   */
   ready : function() {

	  	var page = $( '#current-page' ).data( 'page' );
	  	var route_direction = $( '#route-direction' ).val();
	  	var route_name = $( '#route-name' ).val();

	  	if (page == 'stop-details'){
			
			 $('#stop-details-table tr').each(function (i, row) {
			 	  
			 	  var row = row;
			 	  var stop_name = $(this).children('td:first').text().trim();
			 	  $.get( '/stop_detail.json?stopName=' + stop_name, function( data ) {

			 	  	$(row).children('td:eq(1)').text(data['distance_between']);
			 	  	$(row).children('td:eq(2)').text('Not Running');

			 	  	var route_stop_times = data['RTT']['AgencyList']['Agency']['RouteList']['Route'];
						$.each( route_stop_times, function( index, value ){
						   	 if (value['Name'] == route_name){
						   	 	var route_direction_node = value['RouteDirectionList']['RouteDirection'];
						   	 	$.each( route_direction_node, function( index, a_direction_node ){
						   	 		if (a_direction_node['Name'] == route_direction){
						   	 			var arives_in = a_direction_node['StopList']['Stop']['DepartureTimeList']['DepartureTime'];
						   	 			$(row).children('td:last').text(arives_in);
						   	 		}
						   	 	});
						   	 }
						});
					});	
			 });
	  	};

    	$('#user-submit-form').bind( 'submit', function() {
	      return false;
	    } );

  }


 }