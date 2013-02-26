require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)

CapistranoEden.with_configuration do

  namespace :deploy do

    desc '(config_files.rb) [internal] Replace named files with a symlink to their counterparts in shared/'
    task :do_config_files, :except => { :no_release =>  true } do

      cmds = []
      config_files.each do |files,destination|

        raise "Destination path is nil!" if destination.nil?
        cmds <<-CMD.compact
          for f in  `/bin/ls -1 #{shared_path}/config/#{files}` ; \
          do ln -snf ${f}  #{latest_release}/#{destination}/${f##*/} ; done
        CMD

      end
      run cmds.join(';') if cmds.any?

    end
    after "deploy:symlink", "deploy:do_config_files"

  end # namespace

end


