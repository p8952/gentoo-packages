task :default

@path = File.expand_path(File.dirname(__FILE__))

task :sync_ebuilds do
  FileUtils.mkdir("#{@path}/lib/ebuilds") unless File.directory?("#{@path}/lib/ebuilds")
  pipe = IO.popen("rsync --recursive --compress --delete --verbose --include='*/' --include='*.ebuild' --exclude='*' rsync://mirror.bytemark.co.uk/gentoo-portage/ lib/ebuilds/")
  while (line = pipe.gets)
    print '.'
  end
end

task :build_db => [:sync_ebuilds] do
  ruby "#{@path}/lib/build_db.rb"
end
