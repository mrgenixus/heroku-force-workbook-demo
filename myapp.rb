require "sinatra/base"
require 'force'
require "omniauth"
require "omniauth-salesforce"
require "slim"
require "pry"

class MyApp < Sinatra::Base

  configure do
    enable :logging
    enable :sessions
    set :port, ENV['PORT'] unless ENV['PORT'].nil?
    set :show_exceptions, false
    set :session_secret, ENV['SECRET']
  end

  use OmniAuth::Builder do
    provider :salesforce, ENV['SALESFORCE_KEY'], ENV['SALESFORCE_SECRET']
  end

  before /^(?!\/(auth.*)?)$/ do
    redirect '/authenticate' unless session[:instance_url]
  end

  helpers do
    def client
      @client ||= Force.new username: ENV['SALESFORCE_USERNAME'],
                            password: ENV['SALESFORCE_PASSWORD'],
                            security_token: ENV['SALESFORCE_SECURITY_TOKEN'],
                            client_id:     ENV['SALESFORCE_KEY'],
                            client_secret: ENV['SALESFORCE_SECRET']
    end

  end


  get '/' do
    slim :index
  end

  get '/forceme' do
    logger.info "Visited home page"
    @accounts= client.query("select Id, Name from Account")
    erb :forceme
  end

  get '/orders' do
    @description = client.describe('Order')
    @orders = client.query("SELECT Id, Name, AccountId FROM Order")
    slim :orders
  end


  get '/authenticate' do
    redirect "/auth/salesforce"
  end


  get '/auth/salesforce/callback' do
    logger.info "#{env["omniauth.auth"]["extra"]["display_name"]} just authenticated"
    credentials = env["omniauth.auth"]["credentials"]
    session['token'] = credentials["token"]
    session['refresh_token'] = credentials["refresh_token"]
    session['instance_url'] = credentials["instance_url"]
    redirect '/'
  end

  get '/auth/failure' do
    params[:message]
  end

  get '/unauthenticate' do
    session.clear
    'Goodbye - you are now logged out'
  end

  error Force::UnauthorizedError do
    redirect "/auth/salesforce"
  end

  error do
    "There was an error.  Perhaps you need to re-authenticate to /authenticate ?  Here are the details: " + env['sinatra.error'].name
  end

  run! if app_file == $0

end
