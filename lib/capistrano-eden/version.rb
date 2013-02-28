require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)
require File.dirname(__FILE__) + '/branch'

# used in gemspec
module Capistrano
  module Eden
    VERSION = "0.0.1"
  end
end

CapistranoEden.with_configuration do

  namespace :deploy do

    desc "(version.rb) [internal] Write the name of the tag that we're deploying to a VERSION file"
    task :write_version_file, :except => { :no_release =>  true } do

      if    ENV['TAG']    then _msg = "TAG=#{branch}"
      elsif ENV['BRANCH'] then _msg = "BRANCH=#{branch}"
      else                     _msg = "#{branch}"
      end

      puts "  * Version [#{_msg}]"
      run <<-CMD.compact
          echo  'Version is #{_msg}' >  #{release_path}/VERSION" ;
          [ -d #{release_path}/public ] &&
          echo  'Version is #{_msg}' >  #{release_path}/public/_v.html"
      CMD

    end
    after "deploy:update_code", "deploy:write_version_file"

  end # namespace

end

