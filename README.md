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

* *__config__* keeps files from the *__current/config__* dir that are important BETWEEN different deploys.
* *__sh__* keeps files from the *__current/scripts__* dir that are important BETWEEN different deploys.
* *__shared__* is abolished, because we navigate on those dirs very often and an extra subdir is a nuisance to cd into.
* *__bundle__* is kept one level up, so we can share it between deploys.
* *__tmp__* is kept one level up, so we can share it between deploys.
* *__releases__* is a localtime timestamp with an extra mask.


Those differences are basically of 2 kinds:

1. Extra dirs: *__bundle__*, *__sh__*, *__config__*
2. Abolish of *__shared__*: easily implemented by assuming:

        # [shared_path] = [deploy_to]
        set :shared_path, "#{deploy_to}"


## Rails Stuff



### finalize_update


'finalize_update' in a Rails deploy is about touchinf files inside 'public_dir'



### assets
