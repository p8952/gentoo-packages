task :default
task :clean => [:clean_ebuilds, :clean_db]

@path = File.expand_path(File.dirname(__FILE__))

task :clean_ebuilds do
  FileUtils.rm_rf("#{@path}/lib/ebuilds") if File.directory?("#{@path}/lib/ebuilds")
end

task :sync_ebuilds => [:clean_ebuilds] do
  FileUtils.mkdir("#{@path}/lib/ebuilds") unless File.directory?("#{@path}/lib/ebuilds")
  %x[rsync -v --archive --compress --include='*/' --include='*.ebuild' --exclude='*' rsync://mirror.bytemark.co.uk/gentoo-portage/ lib/ebuilds/]
end

task :clean_db do
  FileUtils.rm("#{@path}/lib/db.sqlite") if File.file?("#{@path}/lib/db.sqlite")
end

task :build_db => [:clean_db, :sync_ebuilds] do
  FileUtils.rm_rf("#{@path}/lib/db.sqlite") if File.file?("#{@path}/lib/db.sqlite")
  ruby "#{@path}/lib/build_db.rb"
end
