require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)

CapistranoEden.with_configuration do

  namespace :eden do

    desc <<-'DESC'
    use 'cap -e eden:do_symlinks' for more.

    (symlinks.rb) Symlink of any file.

    After requiring this helper, set the paths to be symlinked using the
    :symlinks variable:

        ### Example 1:
        ### Symlink inside RAILS_ROOT
        ###     source => destination
        set :symlinks, {
            '/data/libc'       => "#{latest_release}/public/libc"  ,
            '/data/tst/assets' => "#{latest_release}/public/assets",
            '/data/tst/static' => "#{latest_release}/public/static"
        }

        ### Example 2:
        ### Symlink around the server
        ###     source => destination
        set :symlinks, {
            "#{latest_release}/objects"    => '/etc/icinga/objects',
            "#{latest_release}/icinga.cfg" => '/etc/icinga/icinga.cfg',
            "#{latest_release}/xpto.cfg"   => '/etc/icinga/xpto.cfg'
        }

    DESC
    task :do_symlinks, :except => { :no_release =>  true } do

      cmds = []
      symlinks.each do |source,destination|

        cmds << '/bin/rm -rf #{destination} && ln -nsf #{source} #{destination}'

      end
      run cmds.join(';') if cmds.any?

    end
    after "deploy:create_symlink", "eden:do_symlinks"

  end # namespace

end


