DohKem
========

DohKem is a library for quickly installing all my (Kem's) doh preferences, primarily at the time of this writing

``` ruby
require 'doh/scriptapp'
# the above require sets it up so that 
1) config/active_runnable.rb is loaded
2) a log file is set up to output to /doh/log if that directory exists, or Doh.home/log if not
3) any logging >= INFO goes to console (to make all go there, just put Doh.config[:console_log_level] = DohLog::DEBUG  into your active_runnable.rb
4) any logging >= NOTIFY gets emailed to Doh.config[:alerts_email] using smtp server Doh.config[:alerts_smtp_server] (should be set up in your active_runnable.rb -- has defaults)

```
