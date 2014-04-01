require 'nyulibraries/deploy/capistrano'

set :app_title, "campusmedia_solr"

namespace :deploy do
  task :create_symlink do
    run "rm -rf #{app_path}#{app_title} && ln -s #{current_path} #{app_path}#{app_title}"
  end
  task :create_current_path_symlink do
    run "rm -rf #{current_path} && ln -s #{current_release} #{current_path}"
  end
  task :replace_solr_url do
    run "sed -i 's/SOLR_URL_REPLACE/#{ENV["SOLR_URL"]}/g' #{current_release}/lib/SolrWrapper.php"
  end
end

after "deploy", "deploy:create_symlink", "deploy:create_current_path_symlink", "deploy:replace_solr_url"