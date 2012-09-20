begin
  require 'doh/app/origin'
rescue Doh::DohRootNotFoundException
  puts 'Unable to find dohroot -- this script needs to exist on the filesystem in a directory with a parent directory containing a file "dohroot".  It does this in order to find the lib/ and config/ subdirectories'
  exit 1
end
require 'doh/log'
require 'doh/log/stream_acceptor'
require 'doh/log/filter_acceptor'
require 'doh/log/multi_acceptor'
require 'doh/log/email_acceptor'
require 'doh/config'

#kjmtodo -- perhaps make this load production / development or something? -- or make them be links on the local filesystem?
Doh.load_config_file('active_runnable')

module Util
  def self.source_ip
    "not overridden"
  end
end

if FileTest::directory?('/doh/log')
  logdirname = '/doh/log'
else
  logdirname = File.join(Doh::root, 'log')
end
Dir::mkdir(logdirname) if !FileTest::directory?(logdirname)

console_acceptor = DohLog::StreamAcceptor.new(Doh.config[:flush_console_output] == nil ? true : Doh.config[:flush_console_output], STDOUT)
filtered_console_acceptor = DohLog::FilterAcceptor.new(console_acceptor) {|event| event.severity >= (Doh.config[:console_log_level] || DohLog::INFO)}

filename = File.join(logdirname, File.basename($0, '.*') + '.log')
file_acceptor = DohLog::StreamAcceptor.new(true, File.new(filename, Doh.config[:file_acceptor_mode] || 'a'))

email_acceptor = DohLog::EmailAcceptor.new(:from => Doh.config[:alerts_email], :to => [Doh.config[:alerts_email] || 'kem.notify@gmail.com'], :server => Doh.config[:alerts_smtp_server] || '127.0.0.1'){ {:remote_ip => Util.source_ip, :logfile_name => filename, :server => Socket.gethostname} }
filtered_email_acceptor = DohLog::FilterAcceptor.new(email_acceptor) {|event| event.severity >= DohLog::NOTIFY}

multi_acceptor = DohLog::MultiAcceptor.new(filtered_console_acceptor, filtered_email_acceptor, file_acceptor)
DohLog::setup(multi_acceptor)
