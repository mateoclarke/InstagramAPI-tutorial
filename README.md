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

Let's take care of our styling in two css files that will sit in a folder called public. Create a ```public``` directory. Inside that folder, place these two files, [```reset.css```](https://github.com/mateoclarke/InstagramAPI-tutorial/blob/final/public/reset.css) and [```style.css```](https://github.com/mateoclarke/InstagramAPI-tutorial/blob/final/public/style.css).

## Integrating Instagram API

Now, we are finally at the meat of this tutorial, adding photos from Instagram.

What we want to do is call a specific hashtag and see the most recent images that have been uploaded to instagram. Here is the code snippet you can add to your ```instaclown.rb``` file:
	
	def recent_photos (hashtag = "clown", resolution = "thumbnail")
  	  @photos = []
  	  instagram_response = "https://api.instagram.com/v1/tags/#{hashtag}/media/recent?client_id=[YOUR_CLIENT_ID]"
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

In the ```instagram_response``` line, replace ```[YOUR_CLIENT_ID]``` with the client ID you got from the [Instagram Developer's registration page](http://instagram.com/developer/clients/register/). 

Let's run our server with ```ruby instaclown.rb``` and see if this all works.

*SPOILER ALERT: Notice that our default arguements are ```hashtag = 'clown'``` and ```resolution = 'thumbnail'```. We can change these arguments for other searches.*
	

## Going a step further

Now, what if we want to be able to search for more than just clown pictures. Let's add params to our route so we can GET other images as well. Add this to your ```instaclown.rb``` file:
	
	get '/:resolution/:hashtag' do
	  @title = 'Photos'  
	  @photos = recent_photos(params[:hashtag],params[:resolution])
	  erb :all_photos
	end
	
Now try these params in the URL: <http://localhost:4567/low_resolution/sunsets>

Instagram gives us images in three sizes: low_resolution (306x306), standard_resolution (640x640), and thumbnail (150 x 150). 

## Finishing touches

And finally, let's allow our users to search photos more intuitively with a **search form**.

To do this, we need to add a POST route to our ```instaclown.rb``` file :
 
 	post '/search' do
	  @title = params["hashtag"].capitalize
	  @photos = recent_photos(params["hashtag"],params["resolution"])
	  erb :all_photos
	end
	
We also need to add the actual form to the ```all_photos.erb``` view file above the exisiting code. In addition to getting a search field, we'll have a dropdown menu, so users can select their photos' resolution:

	<form id="search-photos" action="/search" method="post" style="text-align:center">
	  <input name="hashtag" type="text" placeholder="#hashtag" />
	  <select name="resolution">
    <option value="" disabled selected>Pick the size</option>
    <option value="thumbnail">Thumbnail</option>
    <option value="low_resolution">Low Resolution</option>
    <option value="standard_resolution">Standard Resolution</option>
	  </select>
	  <input type="submit" name="submit" value="search" /> 
	</form>
	<br>

## That's all it takes to use the Instagram API!

#### Special thanks to [Andrew](https://github.com/akrueger), [Clay](https://github.com/clamstew) & [Gene](https://github.com/GeneChatham) for their help with this tutorial.


