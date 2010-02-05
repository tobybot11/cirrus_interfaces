$:.unshift('lib')
require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "cirrus_interfaces"
    gem.summary = %Q{TODO: one-line summary of your gem}
    gem.description = %Q{TODO: longer description of your gem}
    gem.email = "troy.stribling@usi.net"
    gem.homepage = "http://github.com/troystribling-att/cirrus_interfaces"
    gem.authors = ["troystribling-att"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'cucumber/rake/task'
 
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty"
end
