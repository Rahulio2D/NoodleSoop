require 'thor'
require 'noodle_soop/commands/prepare'

module NoodleSoop
    class CLI < Thor
        desc "prepare", "Generate a template for a NoodleSoop website"
        def prepare(website_path)
            raise ArgumentError, "Website path is required" if website_path.nil? || website_path.empty?

            Commands::Prepare.new(website_path).call
        end
    end
end