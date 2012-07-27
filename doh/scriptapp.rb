require 'doh/app/origin'
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

console_acceptor = DohLog::StreamAcceptor.new(true, STDOUT)
filtered_console_acceptor = DohLog::FilterAcceptor.new(console_acceptor) {|event| event.severity >= (Doh.config[:console_log_level] || DohLog::INFO)}

filename = File.join(logdirname, File.basename($0, '.*') + '.log')
file_acceptor = DohLog::StreamAcceptor.new(true, File.new(filename, 'w+'))

email_acceptor = DohLog::EmailAcceptor.new(:from => Doh.config[:alerts_email], :to => [Doh.config[:alerts_email] || 'kem.notify@gmail.com'], :server => Doh.config[:alerts_smtp_server] || '127.0.0.1'){ {:remote_ip => Util.source_ip, :logfile_name => filename, :server => Socket.gethostname} }
filtered_email_acceptor = DohLog::FilterAcceptor.new(email_acceptor) {|event| event.severity >= DohLog::NOTIFY}

multi_acceptor = DohLog::MultiAcceptor.new(filtered_console_acceptor, filtered_email_acceptor, file_acceptor)
DohLog::setup(multi_acceptor)
