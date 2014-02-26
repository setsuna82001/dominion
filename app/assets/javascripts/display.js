$(function(){
//================================================================
	$('input[name=allselect]').click( function() {
		$.each( $('input[type=checkbox]'), function() {
			if( !( /^series_\d$/.test( this.id ) ) ) return;
			// select
			$( this ).attr( 'checked', true );
		});
	});
	
	$('input[name=newlist]').click( function() {
		
		// checked series count
		series = new Array();
		$.each( $('input[type=checkbox]'), function() {
			if( !( /^series_\d$/.test( this.id ) ) ) return;
			// select
			if( $( this ).is( ':checked' ) ){
				series.push( this.value );
			}
		});
		if ( series.length == 0 ) return;
		
		$( 'input[name=mainlist]' ).attr( 'disabled', 'disabled' );
//		$( 'input[name=sublist]'  ).attr( 'disabled', 'disabled' );
//		$( 'input[name=decklist]' ).attr( 'disabled', 'disabled' );
		$( 'input[name=submit]' ).click();
	} );

})