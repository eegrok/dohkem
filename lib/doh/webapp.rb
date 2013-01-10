begin
  require 'doh/app/origin'
rescue Doh::DohRootNotFoundException
  puts 'Unable to find dohroot -- this script needs to exist on the filesystem in a directory with a parent directory containing a file "dohroot".  It does this in order to find the lib/ and config/ subdirectories'
  exit 1
end
require 'doh/config'
require 'doh/env'
require 'doh/logging_config'

$LOAD_PATH.push(Doh.root)

