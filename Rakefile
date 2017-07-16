require './submetrics'
require 'resque/tasks'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

require_relative "get_data"




desc "Load Customer Table"
task :load_customer do
  MySubMetrics::RechargeInfo.new.load_customer_table

end

desc "Load Subscriptions Table"
task :load_subscriptions do
  MySubMetrics::RechargeInfo.new.load_subscriptions_table

end

desc "Load Order Table"
task :load_order do
  MySubMetrics::RechargeInfo.new.load_order_table

end

desc "Load charges Table"
task :load_charge do
  MySubMetrics::RechargeInfo.new.load_charges_table

end



desc "Load Metrics table"
task :load_metrics do
  MySubMetrics::RechargeInfo.new.load_metrics_table
end