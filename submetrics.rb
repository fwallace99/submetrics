#file submetrics.rb

require 'sinatra/base'
require 'json'
require 'httparty'
require 'dotenv'
require 'resque'
require 'mysql2'
#require 'active_support/core_ext'
require 'sinatra/activerecord'

require './models/model'

#require_relative 'some_helpers'

class SubMetric < Sinatra::Base
    register Sinatra::ActiveRecordExtension

configure do
    enable :logging
    set :server, :puma
    Dotenv.load
    #set :protection
    #set :database, {adapter: "mysql2", database: "submetrics"}
    #ENV variables here, REDIS
    #set :database, {adapter: "mysql2", database: "submetrics"}

end


def initialize
    #some instance variable
    super
end

get '/store_submetrics' do
    puts "At Submetrics for store"
    @my_metrics = Metric.find_by store_id: 1
    puts @my_metrics.inspect
    erb :store_view

end



end