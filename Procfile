web: bundle exec rackup config.ru -p $PORT
worker: COUNT=1 QUEUE=* rake resque:work QUEUE='*'