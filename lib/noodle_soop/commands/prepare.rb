module NoodleSoop
    module Commands
        class Prepare
            TEMPLATE_DIR = File.expand_path("../template", __dir__)

            def initialize(website_path)
                @website_path = website_path
            end

            def call
                puts "Creating a new NoodleSoop website: #{website_path}..."

                validate_website_path!
                make_website_directory
                # TODO: Modify template files somehow

                puts "Finished creating the website: #{website_path}"
            rescue StandardError => e
                puts "An error occurred: #{e.message}"
            end

            private

            def validate_website_path!
                return unless Dir.exists?(website_path) 

                raise StandardError, "Directory already in use at /#{website_path}"
            end

            def make_website_directory
                FileUtils.mkdir_p(website_path)

                dest_path = File.join(Dir.pwd, website_path)
                FileUtils.cp_r("#{TEMPLATE_DIR}/.", dest_path)
            end

            attr_reader :website_path
        end
    end
end