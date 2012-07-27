require 'rake'

Gem::Specification.new do |s|
  s.name = 'dohkem'
  s.version = '0.0.2'
  s.summary = "Kem's default doh setup"
  s.description = "Can require 'doh/scriptapp' for default script settings, e.g."
  s.require_path = 'lib'
  s.required_ruby_version = '>= 1.9.2'
  s.add_runtime_dependency 'dohtest', '>= 0.1.1'
  s.add_runtime_dependency 'dohweb', '>= 0.1.4'
  s.add_runtime_dependency 'dohdata', '>= 0.1.2'
  s.add_runtime_dependency 'dohmysql', '>= 0.2.3'
  s.add_runtime_dependency 'dohroot', '>= 0.1.0'
  s.add_runtime_dependency 'dohlog', '>= 0.1.5'
  s.add_runtime_dependency 'dohutil', '>= 0.2.3'
  s.add_runtime_dependency 'mysql2', '>= 0.3.11'
  s.add_runtime_dependency 'sqlstmt', '>= 0.1.1'
  s.add_development_dependency 'dohtest', '>= 0.1.8'
  s.authors = ['Kem Mason']
  s.bindir = 'bin'
  s.homepage = 'https://github.com/atpsoft/dohmysql'
  s.license = 'MIT'
  s.email = ['kem@atpsoft.com']
  s.extra_rdoc_files = ['MIT-LICENSE']
  s.test_files = FileList["{test}/**/*.rb"].to_a
  s.executables = FileList["{bin}/**/*"].to_a.collect { |elem| elem.slice(4..-1) }
  s.files = FileList["{bin,lib,test}/**/*"].to_a
end
