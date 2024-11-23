require "fileutils"

module R0Indexer
  class Installer
    def self.install
      new.install
    end

    def install
      create_r0_directory
      update_gitignore
      create_database
      perform_initial_index
    end

    private

    def create_r0_directory
      FileUtils.mkdir_p(R0Indexer.r0_dir)
      puts "Created .r0 directory"
    end

    def update_gitignore
      gitignore_path = R0Indexer.root.join(".gitignore")

      content = if File.exist?(gitignore_path)
        File.read(gitignore_path)
      else
        ""
      end

      unless content.include?(".r0/")
        File.open(gitignore_path, "a") do |f|
          f.puts "\n# R0 Indexer"
          f.puts ".r0/"
        end
        puts "Updated .gitignore"
      end
    end

    def create_database
      Indexer.new.setup_database
      puts "Created database"
    end

    def perform_initial_index
      Indexer.new.index_repository
      puts "Performed initial indexing"
    end
  end
end
