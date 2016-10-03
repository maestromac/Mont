require 'sqlite3'
require 'find'

PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'
ROOT_FOLDER = File.dirname(__FILE__)

class DBConnection
  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    sql_file = nil
    db_file = nil

    Find.find(ROOT_FOLDER) do |path|
      if path =~ /.*\.db$/
        db_file = path
      elsif path =~ /.*\.sql$/
        sql_file = path
      end
    end

    commands = [
      "rm '#{db_file}'",
      "cat '#{sql_file}' | sqlite3 '#{db_file}'"
    ]

    commands.each { |command| `#{command}` }

    Find.find(ROOT_FOLDER) do |path|
      if path =~ /.*\.db$/
        db_file = path
        break
      end
    end

    DBConnection.open(db_file)
  end

  def self.instance
    reset if @db.nil?

    @db
  end

  def self.execute(*args)
    print_query(*args)
    instance.execute(*args)
  end

  def self.execute2(*args)
    print_query(*args)
    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  private

  def self.print_query(query, *interpolation_args)
    return unless PRINT_QUERIES

    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end
end
