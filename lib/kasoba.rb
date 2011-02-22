require 'rubygems'
require 'highline/import'

class Kasoba
	attr_reader :files
	def initialize(options, regex, replacement)
		@files = FileNavigator.new(options[:dir],options[:extensions])
		@count = options[:count]
		@editor = options[:editor]
		@regex = regex
		@replacement = replacement
		
	end

	def count
		num = 0
		@files.each do |file|
			file.each do |line|
				cline = line.clone
				while (t = cline.partition(@regex)[2]) != "" do
					cline = t
					num = num +1
				end
			end
			file.close
		end
		return num
	end

	def replace
		@files.each do |file|
			File.open(file.path + ".temp","w") do |tmpFile|
				file.each do |line|
					cline = line.clone
					while ((t = cline.partition(@regex))[2] != "") do
						cline = t[2]
						oldline = t.join
						say("<%= color( 'Oldline: #{oldline}' ,:red )%>")
						localreplacement = @replacement.nil?? ask('Type substitution string') : @replacement
						newline = t[0] + localreplacement + t[2]
						say("<%= color( 'Newline: #{newline}' ,:green )%>")

						if agree("Agree?")
							tmpFile.puts newline
						else
							tmpFile.puts oldline
						end
					end
					tmpFile.puts line if !line.match(@regex) 
				end
			end
			filePath = file.path	
			file.close
			File.delete(filePath)
			File.rename(filePath + ".temp", filePath)
		end
	end
end

class FileNavigator
	def initialize(root, extensions)
		extensionsPattern = extensions.nil?? "{.*,}" : ".{" + extensions.join(',') + "}" 
		filePattern = File.join(root.nil?? "**" : File.join(root, "**")  , "*#{extensionsPattern}")
		@fileNames = Dir.glob(filePattern).select {|fileName| File.file?(fileName) }
	end
	def method_missing(name, *args)
		@files.send(name,*args)	
	end
	def [](i)
		File.new(@fileNames[i], 'r')
	end
	def each
		@fileNames.each do |fileName|
			yield(File.new(fileName,'r'))
		end
	end
end
