root = ::File.dirname(__FILE__)
require ::File.join(root, 'gentoo_packages.rb')
run GentooPackages.new
