# MT-AnythingSlider 1.1

From the [AnythingSlider README](http://github.com/dcneiner/AnythingSlider):

> This new AnythingSlider is an attempt at bringing together the functionality of all of those previous (on CSS-Tricks) sliders and adding new features. In other words, to create a really “full featured” slider that could be widely useful. This is the first time (on CSS-Tricks) that one of these sliders is an actual plugin as well, which should make implementing it and customizing it much easier. Keep reading [on GitHub](http://github.com/dcneiner/AnythingSlider) and [CSS-Tricks](http://css-tricks.com/anythingslider-jquery-plugin/). 

> Added features and functionality from Dean Sofer's 1.3.5 [AnythingSlider fork](http://github.com/ProLoser/AnythingSlider).

**Now you can easily use AnythingSlider in Movable Type with this plugin**!

# jQuery Plugin Overview

* Slides are HTML Content (can be anything)
* Optional Next Slide / Previous Slide Arrows
* Navigation tabs are built and added dynamically (any number of slides)
* Optional custom function for formatting navigation text
* Auto-playing (optional feature, can start playing or stopped)
* Each slide has a hashtag (can link directly to specific slides)
* Infinite/Continuous sliding (always slides in the direction you are going, even at "last" slide)
* Multiple sliders allowable per-page
* Pauses autoPlay on hover (option)
* Link to specific slides from static text links
* Optionally autoPlay once through, stopping on the last page

## Usage & Options (defaults)

	$('#slider1').anythingSlider({
		easing: "swing",           // Anything other than "linear" or "swing" requires the easing plugin
		autoPlay: true,            // This turns off the entire FUNCTIONALY, not just if it starts running or not
		startStopped: false,       // If autoPlay is on, this can force it to start stopped
		delay: 3000,               // How long between slide transitions in AutoPlay mode
		animationTime: 600,        // How long the slide transition takes
		hashTags: true,            // Should links change the hashtag in the URL?
		buildNavigation: true,     // If true, builds and list of anchor links to link to each slide
		pauseOnHover: true,        // If true, and autoPlay is enabled, the show will pause on hover
		startText: "Start",        // Start text
		stopText: "Stop",          // Stop text
		navigationFormatter: null, // Details at the top of the file on this use (advanced use)
		buildArrows: true,         // If true, builds the forwards and backwards buttons
		forwardText: "&raquo;",    // Link text used to move the slider forward
		backText: "&laquo;",       // Link text used to move the slider back
		width: null,               // Override the default CSS width
		height: null,              // Override the default CSS height
		resizeContents: true       // If true, solitary images/objects in the panel will expand to fit the panel
	});

# Prerequisites

* Movable Type 4.1 or higher
* [Config Assistant](http://github.com/endevver/mt-plugin-configassistant)
* [TemplateInstaller](http://mt-hacks.com/templateinstaller.html) (Included)

# Installation

This plugin is installed [just like any other Movable Type Plugin](http://www.majordojo.com/2008/12/the-ultimate-guide-to-installing-movable-type-plugins.php).

* TemplateInstaller - Required to easily install all AnythingSlider templates and widgets. If you have TemplateInstaller installed, navigate to `TemplateInstaller/template_sets` and copy the `anythingslider` template set to the same folder on your server.

* AnythingSliderSettings - Required as this plugin controls all the options of the AnythingSlider jQuery script.

* AnythingSlider - Required as this plugin allows you to change panel options for images and entries, it also includes the jQuery scripts and default images used by the plugin.

# Movable Type Plugin Overview

This plugin, based on v1.3.5 of AnythingSlider, allows for blog-level changes to the AnythingSlider options by going to Tools -> Plugins. Beyond the options mentioned above, this allows you to show/hide a couple elements the original did not, from within Movable Type. Putting these options into a Movable Type interface allows you to quickly make modifications, rebuild your templates, and see your results without tinkering with JavaScript for CSS code.

## General Use

While a great deal of flexibility has been revealed in the plugin Settings, you will likely need to tweak the CSS to fit your desired layout. If you plan to use this in your Movable Type site, light editing of the AnythingSlider CSS will be required. 

This project was started so it is easy to use the same code base (AnythingSlider) on multiple Movable Type sites, and multiple blogs within the same install. I encourage you to use this Movable Type plugin in the same manor. It is intentionally built using [Config Assistant](http://github.com/endevver/mt-plugin-configassistant) for both rapid development and modification for others to deploy in their projects. For example, you can easily change the defaults in the `config.yaml` file before you upload the plugin.

## Theme Designers

If you are designing a Melody or Movable Type 4 theme, and want to use a jQuery-based carousel that offers a lot of features, AnythingSlider works great. You can easily modify the defaults in this plugin, .mtml templates and CSS to fit your liking, then deploy AnythingSlider with your theme. Just fork this repository and make your changes.

# Plugin Setup

Navigate to Design > Templates of the Blog you wish to use AnythingSlider and click *Install Templates* under the Actions section of the sidebar. Select the AnythingSlider template set and click Continue - this must be done on every Blog you want to use AnythingSlider in. You may need to refresh the Templates page to see the new templates.  

Edit the Template Module `AnythingSlider HTML Head` only if you have jQuery added to your template already. If that is the case, delete this line:

	<script type="text/javascript" src="<mt:PluginStaticWebPath component="AnythingSlider">jquery-1.4.2.min.js"></script>
	
Add this Template Module to your template, usually in a `HTML Head` or `Header` Template Module in your blog.

	<$mt:Include module="AnythingSlider HTML Head"$>
	
AnythingSlider has installed both Template Modules and Widgets for the carousel, as people design their Index and Archive templates differently. AnythingSlider also provides a number of different formats to display the carousel, the first of which is a simple image based slider. If using Widgets, go to Design > Widgets and add the appropriate AnythingSlider Widget to your Widget Set. If using Template Modules, add it to your blog, like this:

	<$mt:Include module="AnythingSlider Image Slider"$>

# Changelog

### Version 1.1
* Minor bug fix in Template Module code.
* Added features to AnythingSlider Settings and CSS Index Template.

### Version 1.0
* Updated AnythingSlider Settings plugin and CSS with 1.3.5 updates to jQuery plugin by Dean Sofer.
* Setup Template Modules to make it easy to edit and add to a Movable Type site.

### Version 0.5
* AnythingSlider and AnythingSlider Settings plugins based on AnythingSlider 1.2 jQuery plugin by Chris Coyier.

# The Big To-Do #

* Add for the README:
  - instructions for modifying plugin defaults
  - instructions for changing plugin behavior
  - how to add template modules to your own templates
  - info on the default arrows.png sprites and cellshade.png images
  - instructions for linking directly to slides
* Create/update template modules:
  - carousel module for Page-based slides
  - carousel module for Category-based slides
  - carousel module for Folder-based slides
  - update HTML Head to include link functions to easily add links to slides
* AnythingSlider Settings:
  - add the ability to modify colors through the plugin
  - add the ability to modify the width of the slider in plugin settings
* AnythingSlider:
  - add "Slide Type" to allow for article/photo/video slides toggle
  - add in other options for easing from the easing plugin

# About Meancode Media, LLC

We provide web design and development, as well as hosting services. Specializing in Movable Type and blog/CMS design, our goal is to provide users with easy to manage web sites.

[http://www.meancode.com/](http://www.meancode.com/)

# Copyright

Copyright 2010, Meancode Media, LLC. All rights reserved.

# License

This plugin is licensed under the same terms as Perl itself.