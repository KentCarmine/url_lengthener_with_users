enable :sessions

get '/' do
  erb :index
end

get '/user/new' do
  erb :new_user
end

post '/user/new' do
  @user = User.create(email: params[:email], password: params[:password], name: params[:name])
  redirect to '/'
end

get '/login' do
  erb :login
end

post '/login' do
  user = User.authenticate(params[:email], params[:password])
  session[:user_id] = user.id unless user.nil?
  redirect to "/"
end

get '/users' do
  @users = User.all
  erb :user_list
end

get '/users/:id' do
  @user = User.where("id = ?", params[:id]).first
  @user_urls = Url.where("user_id = ?", @user.id)
  @is_current_user = (@user.id == session[:user_id])
  erb :user_page
end

get '/logout' do
  session[:user_id] = nil
  erb :index
end

get '/url/new' do
  erb :new_url
end

post '/url/new' do
  @user = User.where("id=?", session[:user_id]).first
  if @user.nil?
    @url = Url.new(:long_url => params[:url], :user_id => nil)
    was_saved = @url.save
    unless was_saved
        redirect to "/invalid_url"
    else
      lenthened_url = @url.longer_url
      redirect to "/url/new/#{lenthened_url}"
    end
  else
    @url = Url.new(:long_url => params[:url], :user_id => @user.id)
    was_saved = @url.save
    unless was_saved
        redirect to "/invalid_url"
    else
      lenthened_url = @url.longer_url
      redirect to "/url/new/#{lenthened_url}"
    end
  end
end

get '/invalid_url' do
  erb :invalid_url
end

get '/url/new/:longer_url' do
  @lenthened_url = params[:longer_url]
  @user_id = session[:user_id]
  erb :show_longer_url
end


get '/:longer_url' do
  url = Url.where("longer_url = ?", params[:longer_url]).first
  url.increment_click_count
  real_url = url.long_url
  redirect to real_url
end
