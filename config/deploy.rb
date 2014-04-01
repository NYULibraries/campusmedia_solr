require 'nyulibraries/deploy/capistrano/multistage'
require 'nyulibraries/deploy/capistrano/bundler'
require 'nyulibraries/deploy/capistrano/rvm'
require 'nyulibraries/deploy/capistrano/figs'
require 'nyulibraries/deploy/capistrano/config'
require 'nyulibraries/deploy/capistrano/tagging'
require 'nyulibraries/deploy/capistrano/default_attributes'

set :app_title, "campusmedia_solr"

namespace :deploy do
  
  desc "Find the string SOLR_URL_REPLACE and replace it with the WebSolr url from configula"
  task :replace_solr_url do
    run "sed -i.bak 's/SOLR_URL_REPLACE/#{ENV['SOLR_URL']}/g' #{current_release}/lib/SolrWrapper.php"
  end
  
  desc "Disable migrate task outside of rails environment"
  task :migrate do
    # Nothing
  end
  
end

after "deploy", "deploy:replace_solr_url"