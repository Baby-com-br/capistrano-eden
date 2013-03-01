require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)

CapistranoEden.with_configuration do

  namespace :eden do

    desc <<-'DESC'
    use 'cap -e eden:config_files' for more.

    (config_files.rb) Symlink of config files.

    Link all desired config files. Source and destination are assumed to
    be *__#{deploy_to}/config'__* and *__#{latest_release}/config__* dirs.
    Paths are relative, and wildcards can be used.

        ### Symlink from #{deploy_to}/config
        ###           to #{latest_release}/config
        set :config_files, {
            '*.yml'          => "config/",
            'production.rb'  => "config/environments/"
        }

    DESC
    task :do_config_files, :except => { :no_release =>  true } do

      cmds = []
      config_files.each do |files,destination|

        raise "Destination path is nil!" if destination.nil?

        cmds << "for f in $( /bin/ls -1 #{shared_path}/config/#{files} ) "
        cmds << "do ln -snf ${f}  #{latest_release}/#{destination}/${f##*/} ; done "

      end
      run cmds.join(';') if cmds.any?

    end
    after "deploy:create_symlink", "eden:do_config_files"

  end # namespace

end


