require "noodle_soop/commands/prepare"
require "timecop"

RSpec.describe NoodleSoop::Commands::Prepare do
    subject(:call) { described_class.new(website_name).call }
    let(:website_name) { "website_path" }
    let(:directory_exists) { true }
    let(:directory_empty) { true }

    let(:template_dir) { described_class::TEMPLATE_DIR }
    let(:target_dir) { File.join(Dir.pwd, website_name) }
    let(:formatted_date) { "20250510123000" }
    let(:example_blog_post) { File.join(website_name, "_blogs", "example_post.md") }
    let(:renamed_blog_post) { File.join(website_name, "_blogs", "#{formatted_date}_example_post.md")}

    before do
        allow(Dir).to receive(:exists?).with(website_name).and_return(directory_exists)
        allow(Dir).to receive(:empty?).with(website_name).and_return(directory_empty)
        allow(FileUtils).to receive(:mkdir_p).with(website_name)
        allow(FileUtils).to receive(:cp_r)
        allow(File).to receive(:rename)
    end

    around(:each) do |example|
        Timecop.freeze(Time.local(2025, 5, 10, 12, 30, 0)) do
            example.run
        end
    end

    it 'validates the directory does not exist' do
        call

        expect(Dir).to have_received(:exists?).with(website_name)
    end

    it 'validates the directory is empty' do
        call

        expect(Dir).to have_received(:empty?).with(website_name)
    end

    it 'creates the directory' do
        call

        expect(FileUtils).to have_received(:mkdir_p).with(website_name)
    end

    it 'copies the template files' do
        call

        expect(FileUtils).to have_received(:cp_r).with("#{template_dir}/.", target_dir)
    end

    it 'renames the example blog post' do
        call

        expect(File).to have_received(:rename).with(example_blog_post, renamed_blog_post)
    end

    context 'when the directory already exists' do
        context 'when the directory is empty' do
            let(:directory_exists) { false}


            it 'logs an error' do
                call

                # TODO: Check if the error message is logged
            end
        end

        context 'when the directory is not empty' do
            let(:directory_empty) { false }

            it 'logs an error' do
                call

                # TODO: Check if the error message is logged
            end
        end
    end
end

