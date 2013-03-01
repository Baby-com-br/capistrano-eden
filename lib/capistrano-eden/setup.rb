require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)

CapistranoEden.with_configuration do

  namespace :deploy do

    desc '(setup.rb): This task is overwritten by eden:setup'
    task :setup do; end;

  end # namespace

  namespace :eden do

    desc <<-DESC
      First run: create initial directories for all hosts.

      (setup.rb): create initial directories for all hosts.

      For a specific host:

        $ cap HOSTS=new.server.com deploy:setup

      The directory tree is the one defined by eden:defaults.
      For more information: use 'cap -e eden:defaults'

    DESC
    task :setup, :except => { :no_release => true } do

      eden.defaults

      cmds = []
      dirs = [ "#{base_path}"          \
             , "#{deploy_to}"          \
             , "#{releases_path}"      \
             , "#{releases_path}/1"    \
             , "#{config_path}"        \
             , "#{log_path}"           \
             , "#{tmp_path}"           \
             ]

      # extra dirs inside #{shared_path}
      dirs += shared_children.map { |d| File.join(shared_path, d.split('/').last) }

      # do it
      cmds << "#{sudo} mkdir -p #{ dirs.join(' ') }"
      cmds << "#{sudo} chmod -R g+w #{base_path}" if fetch(:group_writable, true)
      cmds << "#{sudo} chown -R #{user}:#{group} #{base_path}"
      cmds << "ln -nfs #{releases_path}/1 #{deploy_to}/current"

      run cmds.join('; '), :pty => true

    end
    before "deploy:setup" , "eden:setup"

  end # namespace

end

