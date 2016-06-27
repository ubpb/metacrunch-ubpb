require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubygems/package"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :create_tar_gz do
  mab_file_names = Dir.glob(File.expand_path('../spec/assets', __FILE__) + '/**/PAD01.*.PRIMO.xml')
  tar_gz_file_name = File.join(File.expand_path('..', __FILE__), 'mab_test_files.tar.gz')
  gzip_writer = Zlib::GzipWriter.new(File.open(tar_gz_file_name, "w"))
  tar_gz_writer = Gem::Package::TarWriter.new(gzip_writer)

  mab_file_names.each do |mab_file_name|
    mab_file_content = File.read(mab_file_name)

    tar_gz_writer.add_file_simple(File.basename(mab_file_name), 0644, mab_file_content.bytesize) do |f|
      f.write mab_file_content
    end
  end

  tar_gz_writer.close
  gzip_writer.close
end
