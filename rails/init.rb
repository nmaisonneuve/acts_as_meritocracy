RAILS_DEFAULT_LOGGER.info "** acts_as_meritocracy: setting up load paths **"

%w{ models controllers helpers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'lib', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.autoload_paths << path
  ActiveSupport::Dependencies.autoload_once_paths.delete(path)
end

require 'acts_as_meritocracy'