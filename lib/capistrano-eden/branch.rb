require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)

CapistranoEden.with_configuration do

  namespace :eden do

    desc <<-DESC
    use 'cap -e eden:set_branch' for more.

    (branch.rb) [internal] Deploy by BRANCH or TAG.

        To deploy by BRANCH:

            $ BRANCH=branch_name cap stage deploy


        To deploy by TAG:

            $ TAG=tag_name cap stage deploy
            $ TAG=SHA1     cap stage deploy


        To deploy 'master' (default):

            $ cap stage deploy

    DESC
    task :set_branch, :except => { :no_release =>  true } do

      if !exists?(:branch)
        set :branch, ENV['TAG'] || ENV['BRANCH'] || 'master'
      end

    end # task
    # on :start, :set_branch
    before  "deploy:update" , "eden:set_branch"
    before  "deploy:migrate", "eden:set_branch"

  end # namespace

end

