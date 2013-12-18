# Using the Instagram API
![Instagram icon](http://www.shapecollage.com/blog/wp-content/uploads/2012/04/instagram-icon.png)

## Overview
Our first hackathon project was a Rails app called EVENTH#SHR that searches for images from events based on a common hashtags via the Instagram API. This tutorial will provide you with a basic understanding of how to use the Instagram API for your own projects and will help you build a Sinatra app that uses the Instagram API.  

### Hello Developers.
Let's go to the [Instagram Developer](http://instagram.com/developer/)'s page first and see what the API can do.

Before we waste our time with **client_ids** or **access_tokens** let's make sure the Instagram API provides a solution worth integrating into our app. 
 
* Search photos by hashtags => [#mkshackathon](https://api.instagram.com/v1/tags/mkshackathon/media/recent?client_id=9b40950622834ebcaa28532352d529e6)
* Seach photos by location => [Foudsquare ID = 102487411](https://api.instagram.com/v1/locations/102487411/media/recent?access_token=7652845.f59def8.108c835bd0624e698084011724dce43e)
* Grab the most [popular photos](https://api.instagram.com/v1/media/popular?client_id=9b40950622834ebcaa28532352d529e6
)


### Register your client with Instagram
* Login to your existing Instagram account (or create a new one).
* Click the Manage Clients button in the top bar.
* Register a New Client 
* input ```http://localhost:4567/``` for OAuth redirect_uri.


## Setup Sinatra
*For a great Sinatra tutorial, visit [Singing with Sinatra by Nettuts+](http://net.tutsplus.com/tutorials/ruby/singing-with-sinatra/).*
*Many of these steps come straight from their tutorial.*

First, let's install sinatra in Terminal.

	gem install sinatra


Open your text editor and create a project folder and a new file named ```instaclown.rb```. Right at the top of this file we ned to require the Sinatra gem.

	require 'sinatra'

Let’s start off by showing some text on our app's homepage. Add the following to your ```instaclown.rb``` application file:
	
	get '/' do
	  "How do you feel about clowns?"
	end

This is a ‘Route’ just like you are familiar with in Rails. Here, we’re telling Sinatra that if the home, or root, URL '/' is requested, using the normal GET HTTP method, to display “How do you feel about clowns?”

Now, in the terminal, let’s start up the server by typing ```ruby instaclown.rb``` in the Terminal. We’re told that Sinatra has “taken the stage” on port 4567, and if we go to <http://localhost:4567/> in a browser, we see “How do you feel about clowns?”.

## Building out our app

Let's go ahead and paste in some code to lay the foundation for our app. Replace the "How do you feel about clowns?" line with the following code so we have a home page that will eventually display photos from Instagram: 

	get '/' do  
	  @title = 'Photos'  
	  @photos = recent_photos
	  erb :all_photos 
	end  

The 4th line, ```erb :all_photos```, is pointing to the **View** file we'll use as a default. Let's make that view page now.

Create a new file called ```views/all_photos.erb```. This means you also need to create a views directory. Inside ```all_photos.erb``` paste this code:
	
	<% if @photos.count > 0 %>
	  <% @photos.each do |photo| %>
	    <img src="<%= photo %>" />
	  <% end %>
	<% else %>
	  <h4>Sorry no photos :( </h4>
	<% end %>

##Layout

Let's now add some HTML structure to our homepage with a Layout page in Views folder. Create a file called ```layout.erb``` and paste in this code:
	
	<!doctype html>  
    <html lang="en">  
	<head>  
  	  <meta charset="utf8">  
  	  <title><%= @title + ' | Instagram API' %></title>  
  	  <link href="/reset.css" rel="stylesheet">  
  	  <link href="/style.css" rel="stylesheet">  
	</head>  
	<body>  
 	  <header>  
   	     <hgroup>  
    	  <h1><a href="/">Instaclowns</a></h1>  
   	      <h2>'cause nobody is neutral on clowns</h2>  
  	     </hgroup>  
  	  </header>  
  
  	  <div id="main">  
        <%= yield %>  
  	  </div>  
  
  	  <footer>  
        <p><small>A makersquare tutorial on Instagram API.</small></p>  
  	  </footer>  
	</body>  
	</html>

## CSS

Let's take care of our styling in two css files that will sit in a folder called public. Create a ```public``` directory. Inside that folder, we will have ```public/reset.css``` and ```public/style.css```

In ```reset.css``` paste this code:

	reset.css/* 
    HTML5 ✰ Boilerplate 
 
    style.css contains a reset, font normalization and some base styles. 
 
    credit is left where credit is due. 
    much inspiration was taken from these projects: 
        yui.yahooapis.com/2.8.1/build/base/base.css 
        camendesign.com/design/ 
        praegnanz.de/weblog/htmlcssjs-kickstart 
	*/  
  
	/* 
    html5doctor.com Reset Stylesheet (Eric Meyer's Reset Reloaded + HTML5 baseline) 
    v1.6.1 2010-09-17 | Authors: Eric Meyer & Richard Clark 
    html5doctor.com/html-5-reset-stylesheet/ 
	*/  
  
	html, body, div, span, object, iframe,  
	h1, h2, h3, h4, h5, h6, p, blockquote, pre,  
	abbr, address, cite, code, del, dfn, em, img, ins, kbd, q, samp,  
	small, strong, sub, sup, var, b, i, dl, dt, dd, ol, ul, li,  
	fieldset, form, label, legend,  
	table, caption, tbody, tfoot, thead, tr, th, td,  
	article, aside, canvas, details, figcaption, figure,  
	footer, header, hgroup, menu, nav, section, summary,  
	time, mark, audio, video {  
	    margin:0;  
	    padding:0;  
	    border:0;  
	    font-size:100%;  
	    font: inherit;  
	    vertical-align:baselinebaseline;  
	}  
	  
	article, aside, details, figcaption, figure,  
	footer, header, hgroup, menu, nav, section {  
	        display:block;  
	}  
	  
	blockquote, q { quotes:none; }  
	  
	blockquote:before, blockquote:after,  
	q:before, q:after { content:''; content:none; } 
	 
	ins { background-color:#ff9; color:#000; text-decoration:none; } 
	 
	mark { background-color:#ff9; color:#000; font-style:italic; font-weight:bold; } 
	 
	del { text-decoration: line-through; } 
	 
	abbr[title], dfn[title] { border-bottom:1px dotted; cursor:help; } 
	 
	table { border-collapse:collapse; border-spacing:0; } 
	 
	hr { display:block; height:1px; border:0; border-top:1px solid #ccc; margin:1em 0; padding:0; } 
	 
	input, select { vertical-align:middle; } 
	 
	/* END RESET CSS */ 
 
	/* font normalization inspired by  from the YUI Library's fonts.css: developer.yahoo.com/yui/ */  
	body { font:13px/1.231 sans-serif; *font-size:small; } /* hack retained to preserve specificity */  
	select, input, textarea, button { font:99% sans-serif; }  
  
	/* normalize monospace sizing 
 	* en.wikipedia.org/wiki/MediaWiki_talk:Common.css/	Archive_11#Teletype_style_fix_for_Chrome */  
	pre, code, kbd, samp { font-family: monospace, sans-serif; }  
  
	/* 
	 * minimal base styles 
	 */  
  
	body, select, input, textarea {  
    	/* #444 looks better than black: twitter.com/H_FJ/statuses/11800719859 */  
    color: #444;  
    	/* set your base font here, to apply evenly */  
    	/* font-family: Georgia, serif;  */  
	}  
  
	/* headers (h1,h2,etc) have no default font-size or margin. define those 	yourself. */  
	h1,h2,h3,h4,h5,h6 { font-weight: bold; }  
  
	/* always force a scrollbar in non-IE: */  
	html { overflow-y: scroll; }  
  
	/* accessible focus treatment: people.opera.com/patrickl/experiments/	keyboard/test */  
	a:hover, a:active { outline: none; }  
  
	a, a:active, a:visited { color: #607890; }  
	a:hover { color: #036; }  
  
	ul, ol { margin-left: 2em; }  
	ol { list-style-type: decimal; }  
  
	/* remove margins for navigation lists */  
	nav ul, nav li { margin: 0; list-style:none; list-style-image: none; }  
  
	small { font-size: 85%; }  
	strong, th { font-weight: bold; }  
  
	td { vertical-align: top; }  
  
	/* set sub, sup without affecting line-height: gist.github.com/413930 */  
	sub, sup { font-size: 75%; line-height: 0; position: relative; }  
	sup { top: -0.5em; }  
	sub { bottombottom: -0.25em; }  
  
	pre {  
    	/* www.pathf.com/blogs/2008/05/formatting-quoted-code-in-blog-posts-	css21-white-space-pre-wrap/ */  
    	whitewhite-space: pre; whitewhite-space: pre-wrap; whitewhite-space: pre-line; word-wrap: break-word;  
    	padding: 15px;  
		}  
  
	textarea { overflow: auto; } /* www.sitepoint.com/blogs/2010/08/20/ie-remove-textarea-scrollbars/ */  
  
	.ie6 legend, .ie7 legend { margin-left: -7px; } /* thnx ivannikolic! */  
  
	/* align checkboxes, radios, text inputs with their label by: Thierry Koblentz tjkdesign.com/ez-css/css/base.css  */  
	input[type="radio"] { vertical-align: text-bottom; }  
	input[type="checkbox"] { vertical-align: bottombottom; }  
	.ie7 input[type="checkbox"] { vertical-align: baselinebaseline; }  
	.ie6 input { vertical-align: text-bottom; }  
  
	/* hand cursor on clickable input elements */  
	label, input[type="button"], input[type="submit"], input[type="image"], button { cursor: pointer; }  
  
	/* webkit browsers add a 2px margin outside the chrome of form elements */  
	button, input, select, textarea { margin: 0; }  
  
	/* colors for form validity */  
	input:valid, textarea:valid   {  }  
	input:invalid, textarea:invalid {  
            border-radius: 1px; -moz-box-shadow: 0px 0px 5px red; -webkit-	box-shadow: 0px 0px 5px red; box-shadow: 0px 0px 5px red;  
	}  
	.no-boxshadow input:invalid, .no-boxshadow textarea:invalid { background-color: #f0dddd; }  
  
	/* These selection declarations have to be separate. 
     No text-shadow: twitter.com/miketaylr/status/12228805301 
     Also: hot pink. */  
	::-moz-selection{ background: #FF5E99; color:#fff; text-shadow: none; }  
	::selection { background:#FF5E99; color:#fff; text-shadow: none; }  
  
	/*  j.mp/webkit-tap-highlight-color */  
	a:link { -webkit-tap-highlight-color: #FF5E99; }  
  
	/* make buttons play nice in IE: 
     www.viget.com/inspire/styling-the-button-element-in-internet-explorer/ 	*/  
	button {  width: auto; overflow: visible; }  
  
	/* bicubic resizing for non-native sized IMG: 
	     code.flickr.com/blog/2008/11/12/on-ui-quality-the-little-things-client-	side-image-resizing/ */  
	.ie7 img { -ms-interpolation-mode: bicubic; }  
	
## More CSS

In ```style.css```, paste this:

	body {  
    margin: 35px auto;  
    width: 640px;  
	}  
	  
	header {  
	    text-align: center;  
	    margin: 0 0 20px;  
	}  
	  
	header h1 {  
	    display: inline;  
	    font-size: 32px;  
	}  
	  
	header h1 a:link, header h1 a:visited {  
	    color: #444;  
	    text-decoration: none;  
	}  
	  
	header h2 {  
	    font-size: 16px;  
	    font-style: italic;  
	    color: #999;  
	}  
	  
	#main {  
	    margin: 0 0 20px;  
	}  
	  
	#add {  
	    margin: 0 0 20px;  
	}  
	  
	#add textarea {  
	    height: 30px;  
	    width: 510px;  
	    padding: 10px;  
	    border: 1px solid #ddd;  
	}  
	  
	#add input {  
	    height: 50px;  
	    width: 100px;  
	    margin: -50px 0 0;  
	    border: 1px solid #ddd;  
	    background: white;  
	}  
	  
	#edit textarea {  
	    height: 30px;  
	    width: 480px;  
	    padding: 10px;  
	    border: 1px solid #ddd;  
	}  
	  
	#edit input[type=submit] {  
	    height: 50px;  
	    width: 100px;  
	    margin: -50px 0 0;  
	    border: 1px solid #ddd;  
	    background: white;  
	}  
	  
	#edit input[type=checkbox] {  
	    height: 50px;  
	    width: 20px;  
	}  
	  
	article {  
	    border: 1px solid #eee;  
	    border-top: none;  
	    padding: 15px 10px;  
	}  
	  
	article:first-of-type {  
	    border: 1px solid #eee;  
	}  
	  
	article:nth-child(even) {  
	    background: #fafafa;  
	}  
	  
	article.complete {  
	    background: #fedae3;  
	}  
	  
	article span {  
	    font-size: 0.8em;  
	}  
	  
	p {  
	    margin: 0 0 5px;  
	}  
	  
	.meta {  
	    font-size: 0.8em;  
	    font-style: italic;  
	    color: #888;  
	}  
	  
	.links {  
	    font-size: 1.8em;  
	    line-height: 0.8em;  
	    float: rightright;  
	    margin: -10px 0 0;  
	}  
	  
	.links a {  
	    display: block;  
	    text-decoration: none;  
	}  
	

## Integrating Instagram API

Now, we are finally at the meat of this tutorial, adding photos from Instagram.

What we want to do is call a specific hashtag and see the most recent images that have been uploaded to instagram. Here is the code snippet you can add to your ```instaclown.rb``` file:
	
	def recent_photos (hashtag = "clown", resolution = "thumbnail")
  	  @photos = []
  	  instagram_response = "https://api.instagram.com/v1/tags/#{hashtag}/media/recent?client_id=11c0139aaea746868b576d8e2bf0743e"
  	  response = Unirest.get(instagram_response)
  	  photos_array = response.body["data"]

  	  photos_array.each do |photo|
    	image = photo["images"][resolution]["url"]
    	@photos << image
  	  end

  	  @photos
	end 
	
Here we are defining a method, ```recent_photos``` to call from our view page that reaches out to the Instagram servers and adds strings with urls of photos with a specific tag to our @photo array. Very simple. 

We are using ```Unirest``` to make our API request so we need to make sure to add it to our gems at the top of this file with ``require 'unirest'``

Let's run our server with ```ruby instaclown.rb``` and see if this all works.

*SPOILER ALERT: Notice that our default arguements are ```hashtag = 'clown'``` and ```resolution = 'thumbnail'```. We can change these arguements for other searches.*
	

## Going a step further

Now, what if we want to be able to search for more than just clown pictures. Let's add params to our route so we can GET other images as well. Add this to your ```instaclown.rb``` file:
	
	get '/:resolution/:hashtag' do
	  @title = 'Photos'  
	  @photos = recent_photos(params[:hashtag],params[:resolution])
	  erb :all_photos
	end
	
Now try these params in the URL: <http://localhost:4567/low_resolution/sunsets>

Instagram gives us images in three sizes: low_resoltion (306x306), standard_resolution (640x640), and thumbnail (150 x 150). 

## Finishing touches

And finally, let's allow our users to search photos more intuitively with a **search form**.

To do this, we need to add a POST route to our ```instaclown.rb``` file :
 
 	post '/search' do
	  @title = params["hashtag"].capitalize
	  @photos = recent_photos(params["hashtag"],params["resolution"])
	  erb :all_photos
	end
	
We also need to add the actual form to the ```all_photos.erb``` view file above the exisiting code:

	<form id="search-photos" action="/search" method="post" style="text-align:center">
	  <input name="hashtag" type="text" placeholder="#hashtag" />
	  <input name="resolution" type="text" placeholder="resolution" />
	  <input type="submit" name="submit" value="search" /> 
	</form>
	<br>

## That's all it takes to use the Instagram API!

#### Special thanks to [Andrew](https://github.com/akrueger), [Clay](https://github.com/clamstew) & [Gene](https://github.com/GeneChatham) for their help with this tutorial.


