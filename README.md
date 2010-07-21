# AnythingSlider Movable Type Plugin (incomplete)

From the [AnythingSlider README](http://github.com/dcneiner/AnythingSlider):

> This new AnythingSlider is an attempt at bringing together the functionality of all of those previous (on CSS-Tricks) sliders and adding new features. In other words, to create a really “full featured” slider that could be widely useful. This is the first time (on CSS-Tricks) that one of these sliders is an actual plugin as well, which should make implementing it and customizing it much easier. Keep reading [on GitHub](http://github.com/dcneiner/AnythingSlider) and [CSS-Tricks](http://css-tricks.com/anythingslider-jquery-plugin/).

Now you can easily use AnythingSlider in Movable Type with this plugin!

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
	   navigationFormatter: null       // Advanced Use: see AnythingSlider README
	});

# Prerequisites

* Movable Type 4.1 or higher
* [Config Assistant](http://github.com/endevver/mt-plugin-configassistant)
* [TemplateInstaller](http://mt-hacks.com/templateinstaller.html) (Included)

# Installation

This plugin is installed [just like any other Movable Type Plugin](http://www.majordojo.com/2008/12/the-ultimate-guide-to-installing-movable-type-plugins.php).

* TemplateInstaller - Required to easily install all AnythingSlider templates and widgets. If you have TemplateInstaller installed, navigate to `TemplateInstaller/template_sets` and copy the `anythingslider` template set to the same folder on your server.

* AnythingSliderSettings - Required as this plugin controls all the options of the AnythingSlider jQuery script.

* AnythingSlider *or* AnythingSliderPages - Install one or the other, **not both**. If your carousel needs to link to Pages and not Entries, install AnythingSliderPages.

# Movable Type Plugin Overview

This plugin, based on v1.2 of AnythingSlider, allows for blog-level changes to the AnythingSlider options by going to Tools -> Plugins. Beyond the options mentioned above, this allows you to show/hide a couple elements the original did not, from within Movable Type. Putting these options into a Movable Type interface allows you to quickly make modifications, rebuild your templates, and see your results without tinkering with JavaScript for CSS code.

## General Use

While a great deal of flexibility has been revealed in the plugin Settings, you will likely need to tweak the CSS to fit your desired layout. If you plan to use this in your Movable Type site, light editing of the AnythingSlider CSS will be required. 

This project was started so it is easy to use the same code base (AnythingSlider) on multiple Movable Type sites, and multiple blogs within the same install. I encourage you to use this Movable Type plugin in the same manor. It is intentionally built using [Config Assistant](http://github.com/endevver/mt-plugin-configassistant) for both rapid development and modification for others to deploy in their projects. For example, you can easily change the defaults in the `config.yaml` file before you upload the plugin.

## Theme Designers

If you are designing a Melody or Movable Type 4 theme, and want to use a jQuery-based carousel that offers a lot of features, AnythingSlider works great. You can easily modify the defaults in this plugin, .mtml templates and CSS to fit your liking, then deploy AnythingSlider with your theme. Just fork this repository and make your changes.

# Plugin Setup

Navigate to Design > Templates of the Blog you wish to use AnythingSlider and click *Install Templates* under the Actions section of the sidebar. Select the AnythingSlider template set and click Continue - this must be done on every Blog you want to use AnythingSlider in. You may need to refresh the Templates page to see the new templates.  

Edit the Template Module `AnythingSlider HTML Head` only if you have jQuery added to your template already. If that is the case, delete this line:

	<script type="text/javascript" src="<mt:AnythingSliderStaticWebPath>jquery-1.4.2.min.js"></script>
	
Add this Template Module to your template, usually in a `HTML Head` or `Header` Template Module in your blog.

	<$mt:Include module="AnythingSlider HTML Head"$>
	
AnythingSlider has installed both Template Modules and Widgets for the carousel, as you people design their Index and Archive templates differently. AnythingSlider also provides a number of different formats to display the carousel, the first of which is a simple image based slider. If using Widgets, go to Design > Widgets and add the appropriate AnythingSlider Widget to your Widget Set. If using Template Modules, add it to your blog, like this:

	<$mt:Include module="AnythingSlider Images Only"$>

# About Meancode Media, LLC

We provide web design and development, as well as hosting services. Specializing in Movable Type and blog/CMS design, our goal is to provide users with easy to manage web sites.

[http://www.meancode.com/](http://www.meancode.com/)

# Copyright

Copyright 2010, Meancode Media, LLC. All rights reserved.

# License

This plugin is licensed under the same terms as Perl itself.