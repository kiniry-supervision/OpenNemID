// initialize functions
$().ready(function() {

	// XHTML compliant _blank target scripts
	// use rel='popup' to open a small popup window
	$('a[rel*=popup]').click(function() {
		window.open(this.href, 'popup', 'resizable=yes,scrollbars=yes,toolbar=no,location=no,menubar=no,width=500,height=500');
		return false;
	});

	// use rel='external' to open an external url in a new window
	$('a[rel*=external]').click(function() {
		window.open(this.href, 'popup', 'resizable=yes,scrollbars=yes,toolbar=yes,location=yes,menubar=yes');
		return false;
	});

});
