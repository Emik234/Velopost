require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'
require_relative './models'

enable :sessions
use Rack::Flash, :sweep => true
set :sessions, true

set :database, "sqlite3:velopost.sqlite3"