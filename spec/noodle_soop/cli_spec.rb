require "spec_helper"
require "thor"
require "noodle_soop/cli"

RSpec.describe NoodleSoop::CLI do
    describe "prepare" do
        subject(:prepare) { described_class.new.invoke(:prepare, [website_name]) }
        
        let(:website_name) { "example.com" }
        let(:mock_prepare_command) { instance_double(NoodleSoop::Commands::Prepare, call: nil) }

        before do
            allow(NoodleSoop::Commands::Prepare).to receive(:new).and_return(mock_prepare_command)
        end

        it "calls the prepare command with the given website name" do  
            prepare

            expect(NoodleSoop::Commands::Prepare).to have_received(:new).with(website_name)
            expect(mock_prepare_command).to have_received(:call)
        end

        context "when no website name is provided" do
            let(:website_name) { nil }

            it "raises an error" do
                expect { prepare }.to raise_error(ArgumentError, "Website name is required")
            end
        end
    end
end