namespace :db do
	desc "Dump schema and data to db/schema.rb and db/data.yml"
	task(:dump => [ "db:schema:dump", "db:data:dump" ])

	desc "Load schema and data from db/schema.rb and db/data.yml"
	task(:load => [ "db:schema:load", "db:data:load" ])

	namespace :data do
		def db_dump_data_file
		  "#{dump_dir}/#{ENV['DATAFILE'] ? ENV['DATAFILE'] : 'data'}.yml"
    end
            
    def dump_dir(dir = "")
      "#{Rails.root}/db#{dir}"
    end

		desc "Dump contents of database to db/data.extension (defaults to yaml)"
		task :dump => :environment do
            format_class = ENV['class'] || "YamlDb::Helper"
            helper = format_class.constantize
            filter = ENV['FILTER_TABLES']
            SerializationHelper::Base.new(helper,filter).dump db_dump_data_file
		end

		desc "Dump contents of database to curr_dir_name/tablename.extension (defaults to yaml)"
		task :dump_dir => :environment do
            format_class = ENV['class'] || "YamlDb::Helper"
            dir = ENV['dir'] || "#{Time.now.to_s.gsub(/ /, '_')}"
            filter = ENV['FILTER_TABLES']
            SerializationHelper::Base.new(format_class.constantize, filter).dump_to_dir dump_dir("/#{dir}")
		end

		desc "Load contents of db/data.extension (defaults to yaml) into database"
		task :load => :environment do
            format_class = ENV['class'] || "YamlDb::Helper"
            helper = format_class.constantize
			SerializationHelper::Base.new(helper).load (db_dump_data_file)
		end

		desc "Load contents of db/data_dir into database"
		task :load_dir  => :environment do
          dir = ENV['dir'] || "base"
          format_class = ENV['class'] || "YamlDb::Helper"
	      SerializationHelper::Base.new(format_class.constantize).load_from_dir dump_dir("/#{dir}")
		end
	end
end
