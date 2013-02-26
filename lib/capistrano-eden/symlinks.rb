require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)

CapistranoEden.with_configuration do

  namespace :deploy do

    desc '(symlinks.rb) [internal] Replace named files with a symlink to their counterparts in shared/'
    task :do_symlinks, :except => { :no_release =>  true } do

      # Create links
      cmds = []
      symlinks.each do |source,destination|
        cmds << "/bin/rm -rf #{destination} && ln -nsf #{source} #{destination}"
      end
      run cmds.join(';') if cmds.any?

    end
    after "deploy:symlink", "deploy:do_symlinks"

  end # namespace

end


