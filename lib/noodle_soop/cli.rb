require 'thor'

module NoodleSoop
    class CLI < Thor
        desc "prepare", "Generate a template for a NoodleSoop website"
        def prepare(website_name)
            puts "Creating a new NoodleSoop website: #{website_name}"

            # TODO: Copy template files to the specified directory
            # Also finalise template details for v0.0.1

            puts "Finished creating the website: #{website_name}"
        end
    end
end