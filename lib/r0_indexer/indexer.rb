require "sqlite3"
require "json"

module R0Indexer
  class Indexer
    def initialize
      @db = SQLite3::Database.new(R0Indexer.db_path.to_s)
      @root_path = R0Indexer.root
    end

    def setup_database
      @db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS files (
          id INTEGER PRIMARY KEY,
          file_path TEXT,
          controller TEXT,
          action TEXT,
          view_path TEXT,
          file_type TEXT,
          metadata TEXT,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
      SQL

      @db.execute "CREATE INDEX IF NOT EXISTS idx_file_path ON files(file_path)"
      @db.execute "CREATE INDEX IF NOT EXISTS idx_controller ON files(controller)"
      @db.execute "CREATE INDEX IF NOT EXISTS idx_action ON files(action)"
    end

    def index_repository
      clear_existing_index
      index_views
      index_controllers
      index_routes
    end

    private

    def clear_existing_index
      @db.execute("DELETE FROM files")
    end

    def index_views
      Dir.glob(File.join(@root_path, "app/views/**/*")).each do |file_path|
        next if File.directory?(file_path)

        relative_path = file_path.sub(@root_path.to_s + "/", "")
        controller, action = extract_controller_action_from_view(relative_path)

        metadata = {
          partial: File.basename(file_path).start_with?("_"),
          format: File.extname(file_path),
          last_modified: File.mtime(file_path).iso8601
        }

        save_to_db(
          file_path: relative_path,
          controller: controller,
          action: action,
          view_path: relative_path,
          file_type: "view",
          metadata: metadata.to_json
        )
      end
    end

    def index_controllers
      Dir.glob(File.join(@root_path, "app/controllers/**/*.rb")).each do |file_path|
        relative_path = file_path.sub(@root_path.to_s + "/", "")
        controller_name = extract_controller_name(relative_path)
        actions = extract_controller_actions(file_path)

        actions.each do |action|
          metadata = {
            last_modified: File.mtime(file_path).iso8601,
            action_type: "method"
          }

          save_to_db(
            file_path: relative_path,
            controller: controller_name,
            action: action,
            view_path: nil,
            file_type: "controller",
            metadata: metadata.to_json
          )
        end
      end
    end

    def index_routes
      return unless File.exist?(@root_path.join("config/routes.rb"))

      metadata = {
        last_modified: File.mtime(@root_path.join("config/routes.rb")).iso8601
      }

      save_to_db(
        file_path: "config/routes.rb",
        controller: nil,
        action: nil,
        view_path: nil,
        file_type: "routes",
        metadata: metadata.to_json
      )
    end

    def extract_controller_action_from_view(path)
      # app/views/posts/index.html.erb -> ["posts", "index"]
      parts = path.sub("app/views/", "").split("/")
      action = File.basename(parts.last, ".*").split(".").first
      controller = parts[0..-2].join("/")
      [controller, action]
    end

    def extract_controller_name(path)
      # app/controllers/posts_controller.rb -> "posts"
      path.sub("app/controllers/", "")
          .sub("_controller.rb", "")
    end

    def extract_controller_actions(file_path)
      content = File.read(file_path)
      # Very basic action detection - you might want to make this more robust
      content.scan(/def\s+(\w+)/).flatten - ["initialize"]
    end

    def save_to_db(params)
      @db.execute(
        "INSERT INTO files (file_path, controller, action, view_path, file_type, metadata)
         VALUES (?, ?, ?, ?, ?, ?)",
        [params[:file_path], params[:controller], params[:action],
          params[:view_path], params[:file_type], params[:metadata]]
      )
    end
  end
end
