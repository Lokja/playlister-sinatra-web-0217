require "rack-flash"

class SongsController < ApplicationController

  enable :sessions
  use Rack::Flash

  get '/songs' do
    @songs = Song.all
    erb :'/songs/index'
  end

  get '/songs/new' do
    erb :'/songs/new'
  end

  post '/songs' do
    artist = Artist.find_or_create_by(name: params["artist"]["name"])
    @song = Song.create(name: params["song"]["name"], artist: artist)
    params["genres"].each do |genre|
      @song.genres << Genre.find_or_create_by(name: genre["name"])
    end
    @song.save
    flash[:message] = "Successfully created song."
    redirect to "/songs/#{@song.slug}"
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/show'
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/edit'
  end

  post '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    artist = Artist.find_or_create_by(name: params["artist"]["name"])
    @song.artist = artist
    params["genres"].each do |genre|
      @song.genres << Genre.find_or_create_by(name: genre["name"])
    end
    @song.save
    flash[:message] = "Successfully updated song."
    redirect to "/songs/#{@song.slug}"
  end

end
