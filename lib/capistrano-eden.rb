require 'capistrano'

unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-eden requires Capistrano 2"
end

class CapistranoEden

  # Execute the given block of code within the context of the capistrano
  # configuration.
  def self.with_configuration(&block)
    Capistrano::Configuration.instance(:must_exist).load(&block)
  end

end

require 'capistrano-eden/multistage'
require 'capistrano-eden/defaults'
require 'capistrano-eden/setup'
require 'capistrano-eden/finalize_update'

require 'capistrano-eden/branch'
require 'capistrano-eden/config_files'
require 'capistrano-eden/symlinks'
require 'capistrano-eden/version'


