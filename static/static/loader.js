// Evelean Loader - Controls the splash screen fade-out animation
(function () {
	'use strict';

	function hideSplashScreen() {
		const splashScreen = document.getElementById('splash-screen');
		if (splashScreen) {
			splashScreen.classList.add('fade-out');
			// Remove from DOM after animation completes
			setTimeout(() => {
				splashScreen.remove();
			}, 500);
		}
	}

	// Hide splash screen when the page is fully loaded
	if (document.readyState === 'complete') {
		hideSplashScreen();
	} else {
		window.addEventListener('load', hideSplashScreen);
	}
})();
