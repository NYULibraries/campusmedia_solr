require 'formaggio/capistrano/multistage'
require 'formaggio/capistrano/default_attributes'
require 'formaggio/capistrano/figs'
require 'formaggio/capistrano/config'
require 'formaggio/capistrano/bundler'
require 'formaggio/capistrano/rvm'
require 'formaggio/capistrano/tagging'

set :app_title, "campusmedia_solr"
set(:app_symlink) { "#{app_path}#{app_title}" }

namespace :deploy do

  desc "Find the string SOLR_URL_REPLACE and replace it with the WebSolr url from configula"
  task :replace_solr_url do
    run "sed -i.bak 's/WEBSOLR_URL_REPLACE/#{ENV['WEBSOLR_URL'].gsub("/","\\/").gsub("?", "\\?")}/g' #{current_release}/lib/SolrWrapper.php"
    run "sed -i.bak 's/SOLR_URL_REPLACE/#{ENV['SOLR_URL'].gsub("/","\\/").gsub("?", "\\?")}/g' #{current_release}/xsl/cm-room-transform.xsl"
  end

  desc "Disable migrate task outside of rails environment"
  task :migrate do
    # Nothing
  end

  desc "Create symbolic link to new version of deployed app"
  task :create_symlink do
    run "rm -rf #{app_symlink} && ln -s #{current_path} #{app_symlink}"
  end

  desc "Create symbolic link to current release"
  task :create_current_path_symlink do
    run "rm -rf #{current_path} && ln -s #{current_release} #{current_path}"
  end

end

after "deploy", "deploy:create_symlink", "deploy:create_current_path_symlink", "deploy:replace_solr_url", "deploy:cleanup"
