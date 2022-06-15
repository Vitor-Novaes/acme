namespace :populate do

  desc "Populate Database by CSV file"
  task database: :environment do
    Order.new.import_data_file()
  end
end
