require "thor"

module R0Indexer
  class CLI < Thor
    desc "install", "Install R0 Indexer"
    def install
      Installer.install
    end

    desc "index", "Reindex the repository"
    def index
      Indexer.new.index_repository
    end

    desc "search TERM", "Search the index"
    def search(term)
      results = Query.new.find_by_path(term)
      puts JSON.pretty_generate(results)
    end

    desc "controller NAME", "Find files for controller"
    def controller(name)
      results = Query.new.find_by_controller(name)
      puts JSON.pretty_generate(results)
    end
  end
end
