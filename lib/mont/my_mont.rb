module Mont
end

module Mont::CLI
  class MyMont < Thor
    desc "new", "Generates a new Mont application."
    def new
      puts "Greetings!"
    end
  end
end
