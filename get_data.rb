require 'dotenv'
#require "pg"
require 'mysql2'
require 'active_support/core_ext'
require "resque"

require 'httparty'

require_relative 'worker_helper'

module MySubMetrics
  class RechargeInfo


    def initialize
      #@shop_id = shop_id
      #$recharge_access_token = "21ac88718be7466a983368e8a1a2fb4c"
      #$my_get_header =  {
      #     "X-Recharge-Access-Token" => "#{$recharge_access_token}"
      #     }
      $host = "localhost"
      $username = "floyd"
      $password = "10tul10"
      $database = "submetrics"
      @client = Mysql2::Client.new(:host => "localhost", :username => "floyd", :password => '10tul10', :database => 'submetrics')
      @shop_ids = Array.new
      puts "starting .."
      results = @client.query("select id, api_key from shops")
      results.each do |row|
          #puts row.inspect
          my_id = row['id']
          my_api_key = row['api_key']
          puts "Doing store id: #{my_id}"
          my_hash = {"store_id" => my_id, "api_key" => my_api_key}
          @shop_ids << my_hash
          end
      process_shops
    end

    def process_shops
      @shop_ids.each do |myshop|
        puts myshop.inspect
        #Resque.enqueue(MyChargeTable, myshop)
        #Resque.enqueue(MyOrderTable, myshop)
        #Resque.enqueue(MyCustomerTable, myshop)
        Resque.enqueue(MySubscriptionTable, myshop)
        end

    end

    

    def load_metrics_table
      num_subs = 0
      num_active = 0
      num_cancelled = 0
      total_sales_prev_month = 0
      now_total_sales = 0
      total_orders_prev_month = 0
      results = $client.query("select count(subscription_id) as num_subs from subscriptions")
      results.each do |row|
        puts row.inspect
        num_subs = row['num_subs'].to_i
        puts num_subs
        end
      #update num_subs into metrics table
      results = $client.query("update metrics set total_subscribers = #{num_subs} where store_id = 1")
      results = $client.query("select count(subscription_id) as num_active from subscriptions where status = 'ACTIVE' ")
      results.each do |row|
        puts row.inspect
        num_active = row['num_active'].to_i
        puts num_active
        end
      results = $client.query("update metrics set active_subscriptions = #{num_active} where store_id = 1")
      results = $client.query("select count(subscription_id) as num_cancelled from subscriptions where status = 'CANCELLED'")
      results.each do |row|
        puts row.inspect
        num_cancelled = row['num_cancelled'].to_i
        puts num_cancelled
        end
      results = $client.query("update metrics set cancelled_subscriptions = #{num_cancelled} where store_id = 1")
      churn = (num_cancelled/num_subs.to_f).round(2)
      puts churn
      results = $client.query("update metrics set churn = #{churn} where store_id = 1")
      my_today = Date.today
      my_prev_month = my_today << 1
      my_prev_month_first = my_prev_month.beginning_of_month
      my_prev_month_last = my_prev_month.end_of_month
      my_begin_this_month = my_today.beginning_of_month
      #puts my_begin_this_month.inspect, my_today.inspect
      #puts my_prev_month_first.inspect, my_prev_month_last.inspect
      my_prev_month_first_query = my_prev_month_first.strftime("%Y-%m-%dT%H:%M:%S")
      my_prev_month_last_query = my_prev_month_last.strftime("%Y-%m-%dT23:59:59")
      my_today_query = my_today.strftime("%Y-%m-%dT%H:%M:%S")
      my_begin_this_month_query = my_begin_this_month.strftime("%Y-%m-%dT%H:%M:%S")
      puts my_prev_month_first_query, my_prev_month_last_query
      puts my_begin_this_month_query, my_today_query
      results = $client.query("select sum(total_price) as total_sales from charges where processed_at >= \'#{my_prev_month_first_query}\' and processed_at <= \'#{my_prev_month_last_query}\' ")
      results.each do |row|
        puts row.inspect
        total_sales_prev_month = row['total_sales'].to_i
        puts total_sales_prev_month
        end
      results = $client.query("update metrics set prev_total_sales = #{total_sales_prev_month} where store_id = 1")
      results = $client.query("select sum(total_price) as now_total_sales from charges where processed_at >= \'#{my_begin_this_month_query}\' and processed_at <= \'#{my_today_query}\' ")
      results.each do |row|
        puts row.inspect
        now_total_sales = row['now_total_sales'].to_i
        puts now_total_sales
        end
      results = $client.query("update metrics set total_sales = #{now_total_sales} where store_id = 1")
      #total_orders_prev_month
      results = $client.query("select count(order_id) as num_orders from store_orders where processed_at <= \'#{my_prev_month_last_query}\' and processed_at >= \'#{my_prev_month_first_query}\' ")
      results.each do |row|
        puts row.inspect
        total_orders_prev_month = row['num_orders'].to_i
        puts total_orders_prev_month
        end
      results = $client.query("update metrics set prev_sales_orders = #{total_orders_prev_month} where store_id = 1")

    end

    def get_customer_count
      customers_count = HTTParty.get("https://api.rechargeapps.com/customers/count", :headers => $my_get_header)
      raw_customers = customers_count.parsed_response
      puts raw_customers.inspect
      #num_customers = JSON.parse(raw_customers)
      total_customers = raw_customers['count']
      total_customers= total_customers.to_i
      return total_customers
    end

    def get_subscription_count
      subscriptions_count = HTTParty.get("https://api.rechargeapps.com/subscriptions/count", :headers => $my_get_header)
      puts subscriptions_count.parsed_response
      num_subs = JSON.parse(subscriptions_count.parsed_response)
      puts num_subs['count']
      subs_num = num_subs['count'].to_i
      return subs_num

    end

    def get_orders_count
      orders_count = HTTParty.get("https://api.rechargeapps.com/orders/count", :headers => $my_get_header)
      #puts orders_count.parsed_response
      num_orders = JSON.parse(orders_count.parsed_response)
      orders_num = num_orders['count'].to_i
      puts orders_num
      return orders_num
      

    end

    def get_charges_count
      charges_count = HTTParty.get("https://api.rechargeapps.com/charges/count", :headers => $my_get_header)
      #puts charges_count.parsed_response
      num_charges = charges_count.parsed_response['count'].to_i
      puts num_charges
      return num_charges
    end

    class MySubscriptionTable
      extend SubmetricsHelper
      @queue = "customer_table"
      def self.perform(params)
        puts "Loading Subscription Table with latest data"
        puts params.inspect
        my_get_header =  {
           "X-Recharge-Access-Token" => "#{params['api_key']}"
           }
        store_id = params['store_id']
        num_subs = get_subscription_count(my_get_header)
        puts "We have #{num_subs} subscriptions to download"
        load_subscriptions_table(my_get_header, num_subs, store_id)
      end

    end


    class MyChargeTable
      extend SubmetricsHelper
      @queue = "charge_table"
      def self.perform(params)
        puts "Loading Charge Table with latest data"
        puts params.inspect
        my_get_header =  {
           "X-Recharge-Access-Token" => "#{params['api_key']}"
           }
        store_id = params['store_id']
        num_charges = get_charges_count(my_get_header)
        puts "We have #{num_charges} charges to download"
        load_charges_table(my_get_header, num_charges, store_id)
      end
    end

    class MyOrderTable
      extend SubmetricsHelper
      @queue = "order_table"
      def self.perform(params)
        puts "Loading Order Table with latest data"
        puts params.inspect
        store_id = params['store_id']
        my_get_header =  {
           "X-Recharge-Access-Token" => "#{params['api_key']}"
           }
        store_id = params['store_id']
        num_orders = get_orders_count(my_get_header)
        puts "We have #{num_orders} orders to download"
        load_order_table(my_get_header, num_orders, store_id)
      end
    end


  class  MyCustomerTable
    extend SubmetricsHelper
    @queue = "customer_table"
    def self.perform(params)
        puts "Loading customer Table with latest data"
        puts params.inspect
        store_id = params['store_id']
        my_get_header =  {
           "X-Recharge-Access-Token" => "#{params['api_key']}"
           }
        store_id = params['store_id']
        num_customers = get_customer_count(my_get_header)
        puts "We have #{num_customers} customers to download"
        load_customer_table(my_get_header, num_customers, store_id)
      end
  
  end

    def load_charges_table
      charge_number = get_charges_count
      puts "number of charges = #{charge_number}"
      page_size = 250
      num_pages = (charge_number/page_size.to_f).ceil
      puts "number of pages for charges = #{num_pages}"
      my_page_number = 0
      statement4 = $client.prepare("insert into charges  (
          address_id,
          billing_address,
          client_details, 
          created_at,
          customer_hash,
          customer_id,
          first_name,
          charge_id,
          last_name,
          line_items,
          processed_at,
          scheduled_at,
          shipments_count,
          shipping_address,
          shopify_order_id,
          status,
          total_price,
          type,
          updated_at
        
              
          )  values ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")


      1.upto(num_pages) do |page|
        my_page_number += 1
        page_charges = HTTParty.get("https://api.rechargeapps.com/charges?limit=250&page=#{page}", :headers => $my_get_header)
        temp_charges = page_charges.parsed_response
        puts temp_charges.inspect
        puts "----------------------"
        temp_charges['charges'].each do |mycharge|
          puts "**********************"
          puts mycharge.inspect
          puts "*********************"

          address_id = mycharge['address_id']
          billing_address = mycharge['billing_address']
          if !billing_address.nil?
            billing_address = mycharge['billing_address'].to_json
            end
          client_details = mycharge['client_details']
          if !client_details.nil?
            client_details = mycharge['client_details'].to_json
            end
          created_at = mycharge['created_at']
          customer_hash = mycharge['customer_hash']
          customer_id = mycharge['customer_id']
          first_name = mycharge['first_name'] 
          id = mycharge['id']
          last_name = mycharge['last_name']
          line_items = mycharge['line_items']
          if !line_items.nil?
            line_items = mycharge['line_items'].to_json
            end
          processed_at = mycharge['processed_at']
          scheduled_at = mycharge['schedule_at']
          shipments_count = mycharge['shipments_count']
          shipping_address = mycharge['shipping_address']
          if !shipping_address.nil?
            shipping_address = mycharge['shipping_address'].to_json
            end
          shopify_order_id = mycharge['shopify_order_id']
          status = mycharge['status']
          total_price = mycharge['total_price']
          type = mycharge['type']
          updated_at = mycharge['updated_at']
          result4 = statement4.execute(address_id, billing_address, client_details, created_at, customer_hash, customer_id, first_name, id, last_name, line_items, processed_at, scheduled_at, shipments_count, shipping_address, shopify_order_id, status, total_price, type, updated_at )

          end

        puts "Done with page number #{my_page_number} out of #{num_pages}"
        sleep 5
        end

    end

    def load_order_table
      number_orders = get_orders_count
      puts "Number of orders is #{number_orders}"
      page_size = 250
      num_pages = (number_orders/page_size.to_f).ceil
      puts "number of pages for subscriptions = #{num_pages}"

      statement3 = $client.prepare("insert into store_orders  (
          order_id,
          transaction_id,
          charge_status,
          payment_processor,
          address_is_active,
          status,
          type,
          charge_id,
          address_id,
          shopify_id,
          shopify_order_id,
          shopify_order_number,
          shopify_cart_token,
          shipping_date,
          scheduled_at,
          shipped_date,
          processed_at,
          customer_id,
          first_name,
          last_name,
          is_prepaid,
          created_at,
          updated_at,
          email,
          line_items,
          variant_title,
          subscription_id,
          quantity,
          shopify_product_id,
          properties,
          total_price,
          shipping_address,
          billing_address
        
              
          )  values ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")

      my_page_number = 0
      1.upto(num_pages) do |page|
        page_orders = HTTParty.get("https://api.rechargeapps.com/orders?limit=250&page=#{page}", :headers => $my_get_header)
        temp_orders = page_orders.parsed_response
        my_page_number += 1
        puts temp_orders.inspect
        puts "-----------------"
        temp_orders['orders'].each do |mytemp|
          puts "*****************"
          puts mytemp.inspect
          puts "****************"
          id = mytemp['id']
          transaction_id = mytemp['transaction_id']
          charge_status = mytemp['charge_status']
          payment_processor = mytemp['payment_processor']
          address_is_active = mytemp['address_is_active']
          status = mytemp['status']
          type = mytemp['type']
          charge_id = mytemp['charge_id']
          address_id = mytemp['address_id']
          shopify_id = mytemp['shopify_id']
          shopify_order_id = mytemp['shopify_order_id']
          shopify_order_number = mytemp['shopify_order_number']
          shopify_cart_token = mytemp['shopify_cart_token']
          shipping_date = mytemp['shipping_date']
          scheduled_at = mytemp['scheduled_at']
          shipped_date = mytemp['shipped_date']
          processed_at = mytemp['processed_at']
          customer_id = mytemp['customer_id']
          first_name = mytemp['first_name']
          last_name = mytemp['last_name']
          is_prepaid = mytemp['is_prepaid']
          created_at = mytemp['created_at']
          updated_at = mytemp['updated_at']
          email = mytemp['email']
          line_items = mytemp['line_items']
          if !line_items.nil?
            line_items = mytemp['line_items'].to_json
          end
          title = mytemp['title']
          variant_title = mytemp['variant_title']
          subscription_id = mytemp['subscription_id']
          quantity = mytemp['quantity']
          shopify_product_id = mytemp['shopify_product_id']
          properties = mytemp['properties']
          if !properties.nil?
            properties = mytemp['properties'].to_json
            end
          total_price = mytemp['total_price']
          shipping_address = mytemp['shipping_address']
          if !shipping_address.nil?
            shipping_address = mytemp['shipping_address'].to_json
            end
          billing_address = mytemp['billing_address']
          if !billing_address.nil?
            billing_address = mytemp['billing_address'].to_json
            end
          result3 = statement3.execute(id, transaction_id, charge_status, payment_processor, address_is_active, status, type, charge_id, address_id, shopify_id, shopify_order_id, shopify_order_number, shopify_cart_token, shipping_date, scheduled_at, shipped_date, processed_at, customer_id, first_name, last_name, is_prepaid, created_at, updated_at,  email, line_items,  variant_title, subscription_id, quantity, shopify_product_id, properties, total_price, shipping_address, billing_address )



          end

        puts "Done with page #{page} of #{num_pages}"
        sleep 5
        end

    end

    def load_subscriptions_table
      num_subs = get_subscription_count
      page_size = 250
      num_pages = (num_subs/page_size.to_f).ceil
      puts "number of pages for subscriptions = #{num_pages}"
      my_page_number = 0
      statement2 = $client.prepare("insert into subscriptions  (
              subscription_id,
              address_id,
            customer_id,
        created_at,
        updated_at,
        next_charge_scheduled_at,
        cancelled_at,
        product_title,
        variant_title,
        price,
        quantity,
        status,
        shopify_product_id,
        shopify_variant_id,
        sku,
        order_interval_unit,
        order_interval_frequency,
        charge_interval_frequency,
        cancellation_reason,
        order_day_of_week,
        order_day_of_month,
        properties
          )  values ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )")
        
        1.upto(num_pages) do |page|
          page_subscriptions = HTTParty.get("https://api.rechargeapps.com/subscriptions?limit=250&page=#{page}", :headers => $my_get_header)
          temp_subscriptions = page_subscriptions.parsed_response
          my_page_number += 1
          raw_subscriptions = temp_subscriptions['subscriptions']
          raw_subscriptions.each do |mysub|
            puts "----------------"
            puts mysub.inspect
            puts "------------------"
            id = mysub['id']
            address_id = mysub['address_id']
            customer_id = mysub['customer_id']
            created_at = mysub['created_at']
            updated_at = mysub['updated_at']
            next_charge_scheduled_at = mysub['next_charge_scheduled_at']
            cancelled_at = mysub['cancelled_at']
            product_title = mysub['product_title']
            variant_title = mysub['variant_title']
            price = mysub['price']
            quantity = mysub['quantity']
            status = mysub['status']
            shopify_product_id = mysub['shopify_product_id']
            shopify_variant_id = mysub['shopify_variant_id']
            sku = mysub['sku']
            order_interval_unit = mysub['order_interval_unit']
            order_interval_frequency = mysub['order_interval_frequency']
            charge_interval_frequency = mysub['charge_interval_frequency']
            cancellation_reason = mysub['cancellation_reason']
            order_day_of_week = mysub['order_day_of_week']
            order_day_of_month = mysub['order_day_of_month']
            properties = mysub['properties'].to_json
    
            puts "properties = #{properties}"
            result1 = statement2.execute(id, address_id, customer_id, created_at, updated_at, next_charge_scheduled_at, cancelled_at, product_title, variant_title, price, quantity, status, shopify_product_id, shopify_variant_id, sku, order_interval_unit, order_interval_frequency, charge_interval_frequency, cancellation_reason, order_day_of_week, order_day_of_month, properties)
    
          end
        puts "Done with page #{my_page_number} out of #{num_pages}"
  
        sleep 3

        end
    end

    def load_customer_table
      total_customers = get_customer_count
      page_size = 250
      num_pages = (total_customers/page_size.to_f).ceil
      puts "number of pages for customers = #{num_pages}"
      my_page_number = 0
      statement1 = $client.prepare("insert into customers  (
              id,
              hash,
              shopify_customer_id,
            email,
        created_at,
        updated_at,
        first_name,
        last_name,
        billing_address1,
        billing_address2,
        billing_zip,
        billing_city,
        billing_company,
        billing_province,
        billing_country,
        billing_phone,
        processor_type,
        status
          )  values ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )")
        1.upto(num_pages) do |page|
          my_page_number += 1
          page_customer = HTTParty.get("https://api.rechargeapps.com/customers?limit=250&page=#{page}", :headers => $my_get_header)
          temp_customer = page_customer.parsed_response
          #puts temp_orders.inspect
          temp_customer.each do |myord|
              puts "-----------------------------"
              puts myord.inspect
              puts "-----------------------------"
              # my_page_order = myord['orders'][0]
              #puts myord.class
              temp_stuff = myord[1]
              puts temp_stuff
              temp_stuff.each do |funky|
                puts "***************************"
                puts funky.inspect
                id = funky['id']
                hash = funky['hash']
                shopify_customer_id = funky['shopify_customer_id']
                email = funky['email']
                created_at = funky['created_at']
                updated_at = funky['updated_at']
                first_name = funky['first_name']
                last_name = funky['last_name']
                billing_address1 = funky['billing_address1']
                billing_address2 = funky['billing_address2']
                billing_zip = funky['billing_zip']
                billing_city = funky['billing_city']
                billing_company = funky['billing_company']
                billing_province = funky['billing_province']
                billing_country = funky['billing_country']
                billing_phone = funky['billing_phone']
                processor_type = funky['processor_type']
                status = funky['status']
                puts "last_name = #{last_name}"
                result = statement1.execute(id, hash, shopify_customer_id, email, created_at, updated_at, first_name, last_name, billing_address1, billing_address2, billing_zip, billing_city, billing_company, billing_province, billing_country, billing_phone, processor_type, status)
                puts "**************************"
              end
            end
            puts "Done with page #{my_page_number} out of #{num_pages}"
          sleep 3
        end
     
    end



  end
end
