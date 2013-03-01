require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)

CapistranoEden.with_configuration do

  def _mytime
    Time.now.strftime("%Y-%m-%d_%H-%M-%S")
  end

  namespace :eden do

    ###
    ### setup_vars
    ###
    desc <<-DESC
      use 'cap -e eden:default' for more.

      (defaults.rb) [internal] Eden default dirtree.

      Implements the following:
          [deploy_to]
          [deploy_to]/bundle
          [deploy_to]/config
          [deploy_to]/current -> [deploy_to]/releases/2013-01-17_13-11-45
          [deploy_to]/releases
          [deploy_to]/releases/2013-01-17_13-11-45
          [deploy_to]/log
          [deploy_to]/tmp

      Additional itens may be set added defining :shared_children
          [deploy_to]/sh
          [deploy_to]/system
          [deploy_to]/pids

      In this layout shared itens are 1 level up, i.e,
      :deploy_to is equal to :shared_path

    DESC
    task :defaults, :except => { :no_release =>  true } do

        # These are FIXED
        set :release_name  , _mytime()
        set :base_path     , "/eden"
        set :app_path      , "#{base_path}/app"

        set :deploy_to     , "#{app_path}/#{application}"
        set :shared_path   , "#{deploy_to}"

        default_run_options[:pty] = true
        ssh_options[:forward_agent] = true

        # These may be OVERWRITTEN
        _cset :config_path   , "#{shared_path}/config"
        _cset :log_path      , "#{shared_path}/log"
        _cset :tmp_path      , "#{shared_path}/tmp"

        _cset :bundle_dir    , "#{shared_path}/bundle"
        _cset :bundle_flags  , "--deployment --quiet"

        _cset :group         , "app"
        _cset :umask         , "002"

        _cset :keep_releases , 5
        _cset :use_sudo      , true
        _cset :default_shell , "/bin/bash"
        _cset :group_writable, false

    end
    before 'deploy:update' , 'eden:defaults'

    ###
    ### show_vars
    ###
    desc "(defaults.rb) show_defaults: Main variables set by a run session."
    task :show_defaults do

        eden.defaults

        puts "-" * 70
        puts "eden.rb:show_vars - using current values:"
        puts ""
#       puts "              port: #{port}"
#       puts "             umask: #{umask}"
        puts "              user: #{user}"
        puts "             group: #{group}"
        puts "       application: #{application}"
        puts ""
        puts "               scm: #{scm}"
        puts "        repository: #{repository}"
        puts "  repository_cache: #{repository_cache}"
        puts ""
        puts "         base_path: #{base_path}"
        puts "          app_path: #{app_path}"
        puts "       deploy_path: #{deploy_to}"
        puts "      current_path: #{current_path}"
        puts "     releases_path: #{releases_path}"
        puts "       config_path: #{config_path}"
        puts "          log_path: #{log_path}"
        puts "       shared_path: #{shared_path}"
        puts "   shared_children: #{shared_children}"
        puts "    group_writable: #{group_writable}"
        puts ""
        puts "        bundle_dir: #{bundle_dir}"
        puts ""
        puts "  previous_release: #{previous_release}"
        puts "    latest_release: #{latest_release}"
        puts "   current_release: #{current_release}"
        puts "      current_path: #{current_path}"
        puts ""
#       puts " previous_revision: #{previous_revision}"
#       puts "   latest_revision: #{latest_revision}"
#       puts "  current_revision: #{current_revision}"
        puts ""
        puts "-" * 70
        puts ""

    end

  end # namespace

end # CapistranoEden


