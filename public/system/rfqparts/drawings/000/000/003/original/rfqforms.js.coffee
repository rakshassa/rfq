$ ->
  $( '#accordion' ).accordion
    collapsible: true
    heightStyle: "content"    
    icons:
      header: "ui-icon-arrowthick-1-e"
      activeHeader: "ui-icon-arrowthick-1-s"
  $( '#accordion #keep_link' ).click ->
  	window.location = $(this).attr('href');
  	return false;