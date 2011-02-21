#!/usr/bin/env ruby

require 'optparse'

options = {}
optparse = OptionParser.new do |opt|
	opt.on_tail('-h', '--help', 'Show help') do
		puts opt
		exit
	end
	options[:multiple] = false	
	opt.on('-m',  'Have regex work over multiple lines') do
		options[:multiple] = true
	end
	
	options[:dir] = nil 
	opt.on('-d PATH', 'Path whose ancestor files are to be explored') do |path|
		options[:dir] = path
	end

	options[:start] = "0%"
	opt.on('--start START', 'A percentage of the way through to start exploring') do |start|
		options[:start] = start
	end

	options[:end] = "100%"
	opt.on('--end END', 'A percentage of the way through at which to end exploring') do |finish|
		options[:end] = finish 
	end

	options[:extensions] = nil
	opt.on('--extensions x,y,z', Array, 'List of extensions to process') do |list|
		options[:extensions] = list
	end

	options[:editor] = ENV['EDITOR']
	opt.on('--editor EDITOR', 'Specify an editor. If omitted default to $EDITOR enviroment variable') do |editor|
		options[:editor] = editor
	end 

	options[:count] = false
	opt.on('--count', 'Print out number of times places in the codebase match the query') do
		options[:count] = true
	end
	
	options[:test] = false
	opt.on('--test', 'Run the unit tests') do
		options[:test] = true
	end

end.parse!

regex = ARGV[0]
replacement = ARGV[1]
p options
p regex, replacement
extensions = options[:extensions].nil?? "{.*,}" : ".{" + options[:extensions].join(',') + "}" 
filePattern = File.join(options[:dir].nil?? "**" : File.join(options[:dir], "**")  , "*#{extensions}")

files = Dir.glob(filePattern).select {|fileName| File.file?(fileName) }
p filePattern
p files
