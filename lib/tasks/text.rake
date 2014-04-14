 namespace :texting do
    desc "Drop and create the current database"
    task :test => :environment do
      # abcs = A÷÷ææctiveRecord::Base.configurations
      # ActiveRecord::Base.establish_connection(abcs[RAILS_ENV])
      # ActiveRecord::Base.connection.recreate_database(ActiveRecord::Base.connection.current_database)
      TwilioModel.text_test
    end

    desc "Send all texts for the given minute"
    task :send => :environment do
      Trip.get_trips_for_current_minute
    end

    desc "puts something"
    task :print => :environment do
      puts "im putting something"
    end
  end
