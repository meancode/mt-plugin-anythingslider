# AnythingSlider Movable Type Plugin

From the [AnythingSlider README](http://github.com/dcneiner/AnythingSlider):

This new AnythingSlider is an attempt at bringing together the functionality of all of those previous (on CSS-Tricks) sliders and adding new features. In other words, to create a really “full featured” slider that could be widely useful. This is the first time (on CSS-Tricks) that one of these sliders is an actual plugin as well, which should make implementing it and customizing it much easier. Keep reading [on GitHub](http://github.com/dcneiner/AnythingSlider) and [CSS-Tricks](http://css-tricks.com/anythingslider-jquery-plugin/).

# Prerequisites

* Movable Type 4.1 or higher
* [Config Assistant](http://github.com/endevver/mt-plugin-configassistant)

# jQuery Plugin Overview

* Slides are HTML Content (can be anything)
* Next Slide / Previous Slide Arrows
* Navigation tabs are built and added dynamically (any number of slides)
* Optional custom function for formatting navigation text
* Auto-playing (optional feature, can start playing or stopped)
* Each slide has a hashtag (can link directly to specific slides)
* Infinite/Continuous sliding (always slides in the direction you are going, even at "last" slide)
* Multiple sliders allowable per-page (hashtags only work on first)
* Pauses autoPlay on hover (option)
* Link to specific slides from static text links

## Usage & Options (defaults)

	$('.anythingSlider').anythingSlider({
	   easing: "swing",                // Anything other than "linear" or "swing" requires the easing plugin
	   autoPlay: true,                 // This turns off the entire FUNCTIONALITY, not just if it starts running or not
	   startStopped: false,            // If autoPlay is on, this can force it to start stopped
	   delay: 3000,                    // How long between slide transitions in AutoPlay mode
	   animationTime: 600,             // How long the slide transition takes
	   hashTags: true,                 // Should links change the hashtag in the URL?
	   buildNavigation: true,          // If true, builds and list of anchor links to link to each slide
	   pauseOnHover: true,             // If true, and autoPlay is enabled, the show will pause on hover
	   startText: "Start",             // Start text
	   stopText: "Stop",               // Stop text
	   navigationFormatter: null       // Advanced Use: [see README](http://github.com/dcneiner/AnythingSlider)
	});

# Movable Type Plugin Overview

This plugin, based on v1.2 of AnythingSlider, that allows for blog-level changes to the AnythingSlider options in a plugin interface inside of Movable Type. Beyond the options mentioned above, this allows to show/hide a couple elements the original did not from within Movable Type, not requiring editing of JavaScript or CSS files.
