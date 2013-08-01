get '/' do
  redirect to('/packages/')
end

get '/packages/:category?/?' do
  if params[:category].nil?
    erb :home
  else
    erb :packages
  end
end
