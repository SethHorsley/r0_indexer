module R0Indexer
  class Query
    def initialize
      @db = SQLite3::Database.new(R0Indexer.db_path.to_s)
      @db.results_as_hash = true
    end

    def find_by_controller(controller_name)
      query("SELECT * FROM files WHERE controller = ?", controller_name)
    end

    def find_by_action(action_name)
      query("SELECT * FROM files WHERE action = ?", action_name)
    end

    def find_by_path(path)
      query("SELECT * FROM files WHERE file_path LIKE ?", "%#{path}%")
    end

    private

    def query(sql, *params)
      @db.execute(sql, params)
    end
  end
end
