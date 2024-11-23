require "r0_indexer/version"
require "r0_indexer/indexer"
require "r0_indexer/query"
require "r0_indexer/installer"
require "r0_indexer/cli"

module R0Indexer
  class Error < StandardError; end

  def self.root
    @root ||= Pathname.new(Dir.pwd)
  end

  def self.r0_dir
    @r0_dir ||= root.join(".r0")
  end

  def self.db_path
    @db_path ||= r0_dir.join("index.db")
  end
end
