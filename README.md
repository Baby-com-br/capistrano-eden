Capistrano Eden
----------------

A capistrano gem that implements our company defaults.




## Directory Structure


The default [directory structure](https://github.com/capistrano/capistrano/wiki/2.x-From-The-Beginning) in capistrano
assumes this components:

    [deploy_to]
    [deploy_to]/releases
    [deploy_to]/releases/20080819001122
    [deploy_to]/releases/...
    [deploy_to]/shared
    [deploy_to]/shared/log
    [deploy_to]/shared/pids
    [deploy_to]/shared/system
    [deploy_to]/current -> [deploy_to]/releases/20100819001122


*__capistrano-eden__* gem implements the following:

    [deploy_to]
    [deploy_to]/bundle
    [deploy_to]/config
    [deploy_to]/current -> [deploy_to]/releases/2013-01-17_13-11-45
    [deploy_to]/releases
    [deploy_to]/releases/2013-01-17_13-11-45
    [deploy_to]/releases/...
    [deploy_to]/log
    [deploy_to]/pids
    [deploy_to]/system
    [deploy_to]/sh
    [deploy_to]/tmp


The differences are:

* *__config__* keeps files outside *__current/config__* dir that are important BETWEEN different deploys.
* *__sh__* keeps files outside *__current/scripts__* dir that are important BETWEEN different deploys.
* *__shared__* is abolished, because we navigate on those dirs very often and an extra subdir is a nuisance to cd into.
* *__bundle__* is kept one level up, so we can share it between deploys.
* *__tmp__* is kept one level up, so we can share it between deploys.
* *__releases__* is a timestamp in localtime with an extra mask.


Those differences are basically of 2 kinds:

1. Extra dirs: *__bundle__*, *__sh__*, *__config__*
2. Abolish of *__shared__*: easily implemented by assuming:

        # [shared_path] = [deploy_to]
        set :shared_path, "#{deploy_to}"


## capify-eden

An alternative *__capify__* command assumes we use multi-stage by default:

     $ capify-eden

     ./Capfile
     ./config/deploy.rb
     ./config/deploy/dev.rb       # extra: multi-stage
     ./config/deploy/prd.rb       # extra: multi-stage
     ./config/deploy/vagrant.rb   # extra: multi-stage


## Linking files

### Symlinks

During deployment, this helper replaces each of the given paths with a
symbolic link that points to files or directories that contain data
that should persist across deployments (uploads, assets, for example).

After requiring this helper, set the paths to be symlinked using the
:symlinks variable:

    ### Example 1:
    ### Symlink inside RAILS_ROOT
    ###     source => destination
    set :symlinks, {
        '/data/libc'       => "#{latest_release}/public/libc"  ,
        '/data/tst/assets' => "#{latest_release}/public/assets",
        '/data/tst/static' => "#{latest_release}/public/static",
    }

    ### Example 2:
    ### Symlink around the server
    ###     source => destination
    set :symlinks, {
        "#{latest_release}/objects"    => '/etc/icinga/objects',
        "#{latest_release}/icinga.cfg" => '/etc/icinga/icinga.cfg',
        "#{latest_release}/xpto.cfg"   => '/etc/icinga/xpto.cfg',
    }


### Config files

Link all desired config files. Source and destination are assumed to
be *__#{deploy_to}/config'__* and *__#{latest_release}/config__* dirs.
Paths are relative, and wildcards can be used.

    ### Symlink from #{deploy_to}/config
    ###           to #{latest_release}/config
    set :config_files, {
        '*.yml'          => "config/",
        'production.rb'  => "config/environments/"
    }



## Rails Stuff

### finalize_update

Task *__'finalize_update'__* in a Rails deploy is about touching files inside
'public/' dir

Deployment of things that ARE NOT rails generally do not have a *__'public/'__* dir.
To comply with this and avoid error messages in a deploy session just set the
follwing option:


    set :no_rails, true
    set :i_am_not_rails, true


