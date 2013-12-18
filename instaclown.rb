require 'sinatra'
require 'unirest'

get '/' do  
  @title = 'Photos'  
  @photos = recent_photos
  erb :all_photos 
end  
