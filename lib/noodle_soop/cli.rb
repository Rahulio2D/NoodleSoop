require 'thor'
require 'noodle_soop/commands/prepare'

module NoodleSoop
    class CLI < Thor
        desc "prepare", "Generate a template for a NoodleSoop website"
        def prepare(website_name)
            Commands::Prepare.new(website_name).call
        end
    end
end