# Homepage (Root path)
require 'pry'
require 'uri'
require 'cgi'

helpers do
  def current_user
    if session['user_id']
      User.find(session[:user_id])
    end
  end

  def get_embedded_url(url)
    begin
      puts url
      parsed = URI(url)
      query = parsed.query
      params_hash = CGI::parse(query)
      video_id = params_hash["v"][0]
      "http://www.youtube.com/embed/#{video_id}"
    rescue NoMethodError => e
      puts e.message
      return "blah"
    end
  end
end

get '/' do
  erb :index
end

get '/songs' do
  @songs = Song.all
  erb :'songs/index'
end

get '/songs/new' do
  erb :'songs/new'
end

post '/songs' do
  @song = Song.new(
      title: params[:title],
      artist: params[:artist],
      url: params[:url]
  )
  if @song.save
    redirect '/songs'
  else
    erb :'/songs/new'
  end
end

get '/songs/page' do
  erb :'/songs/page'
end

delete '/songs/:id' do |id|
  @song = Song.find(id)
  if @song && @song.user == current_user
    @song.destroy
  end
  redirect '/songs'  
end

# delete 'songs/:id'
#   Song.find(params[:song_id]).try(:destroy)
#   redirect '/songs'
# end


get '/users/new' do
  erb :'users/new'
end

post '/users' do
  @user = User.new(
    name: params[:name],
    email: params[:email],
    password: params[:password]
  )
  if @user.save
    session[:user_id] = @user.id
    redirect '/songs'
  else
    erb :'users/new'
  end
end

post '/login' do
  user = User.find_by(email: params[:email])
  if user && user.password == params[:password]
    session[:user_id] = user.id
    # redirect "/songs"   ???
    @message = "Logged in successfully"
    @songs = Song.all
    erb :'/songs/index'
  else
    @message = "Invalid username or password"
    erb :'/users/new'
  end
end

get '/votes/:id' do
  @song = Song.find params[:id]

  if current_user && Vote.where(user_id: current_user.id, song_id: @song.id).empty?
    @song.votes << Vote.new(user_id: current_user.id)
    @song.save
  end 
    redirect '/songs'
end

get '/logout' do
  session.clear
  redirect '/'
end

