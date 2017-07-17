#task_caller

require 'mysql2'
#require 'resque'


module TaskCaller
  class MyTasks
    def initialize    
      @client = Mysql2::Client.new(:host => "localhost", :username => "floyd", :password => '10tul10', :database => 'submetrics') 
      get_shop_ids       
    end

    def get_shop_ids
        puts "starting .."
        results = @client.query("select id from shops")
        results.each do |row|
            #puts row.inspect
            my_id = row['id']
            puts "Doing store id: #{my_id}"


            end
    end

  end
end