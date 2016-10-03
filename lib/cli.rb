require 'thor'
require 'sails/cli/my_sails'

module Mont
  class MyCli < Thor
    desc "new", "'new' will generate a new Mont application in your working directory.'"

    def new(app_name)
      g = Generator.new
      g.directory "../new_app_files", "./#{app_name.chomp}"
    end
  end
end

class Generator < Thor
  include Thor::Actions

  def self.source_root
    File.dirname(__FILE__)
  end
end
