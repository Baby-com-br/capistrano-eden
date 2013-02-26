require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)

CapistranoEden.with_configuration do

  namespace :deploy do

    desc "(branch.rb) [internal] Ensure that a branch has been selected."
    task :set_branch, :except => { :no_release =>  true } do

      if !exists?(:branch)
        set :branch, ENV['TAG'] || ENV['BRANCH'] || 'master'
      end

    end # task
    # on :start, :set_branch
    before  "deploy:update" , "deploy:set_branch"
    before  "deploy:migrate", "deploy:set_branch"

  end # namespace

end

