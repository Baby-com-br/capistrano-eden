require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)

CapistranoEden.with_configuration do

  namespace :deploy do

    desc '(finalize_update.rb): This task is overwritten by eden:finalize_update'
    task :finalize_update, :except => { :no_release => true } do ; end;

  end # namespace

  ###
  ### Stub: If I need to use in a later time.....
  ###

  namespace :eden do

    desc <<-DESC
      (finalize_update.rb): ensure mode/permission on the :latest_release.
    DESC
    task :finalize_update, :except => { :no_release => true } do

      cmds = []
      cmds << "#{sudo} chmod -R g+w #{latest_release}" if fetch(:group_writable, true)
      cmds << "#{sudo} chown -R #{user}:#{group} #{latest_release}"

      run cmds.join('; '), :pty => true

    end

    after "deploy:finalize_update" , "eden:finalize_update"

  end # namespace

end

