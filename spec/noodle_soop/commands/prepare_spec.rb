# frozen_string_literal: true

require 'noodle_soop/commands/prepare'
require 'timecop'

RSpec.describe NoodleSoop::Commands::Prepare do
  subject(:call) { described_class.new(website_path).call }
  let(:website_path) { 'website_path' }
  let(:directory_exists) { false }
  let(:directory_empty) { true }

  let(:template_dir) { described_class::TEMPLATE_DIR }
  let(:target_dir) { File.join(Dir.pwd, website_path) }
  let(:formatted_date) { '20250510123000' }
  let(:example_blog_post) { File.join(website_path, '_blogs', 'example_post.md') }
  let(:renamed_blog_post) { File.join(website_path, '_blogs', "#{formatted_date}_example_post.md") }

  before do
    allow(Dir).to receive(:exists?).with(website_path).and_return(directory_exists)
    allow(Dir).to receive(:empty?).with(website_path).and_return(directory_empty)
    allow(FileUtils).to receive(:mkdir_p).with(website_path)
    allow(FileUtils).to receive(:cp_r)
    allow(File).to receive(:rename)
  end

  around(:each) do |example|
    Timecop.freeze(Time.local(2025, 5, 10, 12, 30, 0)) do
      example.run
    end
  end

  RSpec.shared_examples 'successfully copies website template' do
    it 'validates the directory does not exist' do
      call

      expect(Dir).to have_received(:exists?).with(website_path)
    end

    it 'creates the directory' do
      call

      expect(FileUtils).to have_received(:mkdir_p).with(website_path)
    end

    it 'copies the template files to the target directory' do
      call

      expect(FileUtils).to have_received(:cp_r).with("#{template_dir}/.", target_dir)
    end

    it 'renames the example blog post' do
      call

      expect(File).to have_received(:rename).with(example_blog_post, renamed_blog_post)
    end
  end

  context 'when the specified directory does not exist' do
    include_examples 'successfully copies website template'
  end

  context 'when the directory already exists' do
    let(:directory_exists) { true }

    it 'validates the directory is empty' do
      call

      expect(Dir).to have_received(:empty?).with(website_path)
    end

    context 'when the directory is empty' do
      include_examples 'successfully copies website template'
    end

    context 'when the directory is not empty' do
      let(:directory_empty) { false }

      it 'raises an error' do
        expect do
          call
        end.to raise_error(CouldNotPrepareWebsiteError, "Directory already in use at /#{website_path}")
      end

      it 'does not copy the template files' do
        begin
          call
        rescue CouldNotPrepareWebsiteError
          # Rescuing expected error
        end

        expect(FileUtils).not_to have_received(:mkdir_p).with(website_path)
      end
    end
  end
end
