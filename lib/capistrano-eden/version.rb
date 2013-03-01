require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)
require File.dirname(__FILE__) + '/branch'

# used in gemspec
module Capistrano
  module Eden
    VERSION = "0.0.1"
  end
end

CapistranoEden.with_configuration do

  namespace :eden do

    desc <<-'DESC'
    use 'cap -e eden:version' for more.

    (version.rb) [internal] Write the name of the deployed tag/branch to a VERSION file:"

        File 1: #{current_path}/VERSION
        File 2: #{current_path}/public/v.html if [ -d #{current_path}/public/ ]


    DESC
    task :write_version, :except => { :no_release =>  true } do

      if    ENV['TAG']    then _ver = "TAG=#{branch}"
      elsif ENV['BRANCH'] then _ver = "BRANCH=#{branch}"
      else                     _ver = "#{branch}"
      end

      _msg = "Deploy: #{_ver}. SHA1: #{latest_revision}"

      puts "  * Version [#{_msg}]"
      run <<-CMD.compact
        echo #{_msg} > #{latest_release}/VERSION ;
        test -d #{latest_release}/public && echo #{_msg} > #{latest_release}/public/_v.html || :
      CMD

    end
    after "deploy:update_code", "eden:write_version"

  end # namespace

end

