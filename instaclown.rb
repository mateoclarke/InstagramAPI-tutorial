require 'sinatra'
require 'bundler'
require 'unirest'

get '/' do  
  @title = 'Photos'  
  @photos = recent_photos
  erb :all_photos 
end  

get '/:resolution/:hashtag' do
  @title = 'Photos'  
  @photos = recent_photos(params[:hashtag],params[:resolution])
  erb :all_photos
end

post '/search' do
  @title = params["hashtag"].capitalize
  @photos = recent_photos(params["hashtag"],params["resolution"])
  erb :all_photos
end

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
