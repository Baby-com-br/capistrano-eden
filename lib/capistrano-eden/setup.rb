require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoAbril)

CapistranoAbril.with_configuration do

  namespace :deploy do

    desc <<-DESC
      (setup.rb): create initial directories for all hosts.
      For a specific host:
        $ cap HOSTS=new.server.com deploy:setup
    DESC
    task :setup, :except => { :no_release => true } do


      cmds = []
      dirs = [ "#{base_path}"          \
             , "#{logs_path}"          \
             , "#{deploy_to}"          \
             , "#{releases_path}"      \
             , "#{releases_path}/1"    \
             , "#{shared_path}"        \
             , "#{shared_path}/config" \
             , "#{config_path}"        \
             ]

      dirs.each do |d|
          cmds << "#{sudo} mkdir -p                #{d}"
          cmds << "#{sudo} chmod g+w               #{d}"
          cmds << "#{sudo} chown #{user}:#{ugroup} #{d}"
      end
      cmds << "ln -nfs #{releases_path}/1 #{deploy_to}/current"
      run cmds.join(';'), :pty => true
    end
    before "deploy:setup" , "deploy:setup_vars"

  end # namespace

end

