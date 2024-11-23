module R0Indexer
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Install R0 Indexer"

      def install
        R0Indexer::Installer.install
      end
    end
  end
end
