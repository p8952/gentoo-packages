get '/:category?/?' do
  if params[:category].nil?
    erb :home
  else
    erb :packages
  end
end
