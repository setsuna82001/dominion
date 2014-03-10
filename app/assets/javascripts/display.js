$(function(){
//================================================================
	
	function eachSeriesCheck( bln ){
		$.each( $('input[type=checkbox]'), function() {
			if( !( /^series_\d$/.test( this.id ) ) ) return;
			$( this ).prop({'checked':bln});
		});
	}
	
	$('#btn_allselect').click( function() {
		eachSeriesCheck( true );
	});
	
	$('#btn_allclear').click( function() {
		eachSeriesCheck( false );
	});

//================================================================
	
	function listDisabling( list ){
		$.each( list, function( id, val ) {
			$( '#' + val ).attr( 'disabled', true );
		});
	}
	

	$('#extract').click( function() {
		
		// checked series count
		series_count = 0;
		$.each( $('input[type=checkbox]'), function() {
			if( !( /^series_\d$/.test( this.id ) ) ) return;
			// select
			if( $( this ).is( ':checked' ) ){
				series_count++;
			}
		});

		if ( series_count == 0 || $('#mainlist').length == 0 ) return;
		
		switch( $('#extract_type option:selected').val() ){
			case 'type_main'	: listDisabling( [ 'mainlist', 'sublist', 'decklist', 'optlist' ] ); break;
			case 'type_sub'		: listDisabling( [ 'sublist' ]  ); break;
			case 'type_deck'	: listDisabling( [ 'decklist' ] ); break;
			case 'type_opt'		: listDisabling( [ 'optlist' ]  ); break;

			case 'type_suball'	: listDisabling( [ 'sublist', 'decklist', 'optlist' ] ); break;
			case 'type_subopt'	: listDisabling( [ 'sublist', 'optlist' ] ); break;
		}
		
		$('#form').submit();
	} );

//================================================================

})