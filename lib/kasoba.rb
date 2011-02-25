require 'rubygems'
require 'highline/import'
require 'rainbow'

class Kasoba
  attr_reader :files
  def run
    if @count == true
      say("Counting ...")
      p count
    else
      replace
    end
  end

  def initialize(options, regex, replacement)
    @files = FileNavigator.new(options[:dir],options[:extensions])
    @count = options[:count]
    @editor = options[:editor]
    @regex = regex
    @replacement = replacement
  end

  def run
    if @count == true
      say("Counting ...")
      p count
    else
      replace
    end
  end

  def count
    num = 0
    @files.each do |file|
      file.each do |line|
        cline = line.clone
        while ((t = cline.partition(@regex)[2]) != "") or (cline.match(@regex)) do
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
        p file.path
        fileContent = file.readlines.join
        while (((t = fileContent.partition(Regexp.new(@regex)))[2] != "") or t.join.length > 0)
          if(t[2] != "")
            tmpFile << t[0]
            fileContent = t[2]
            oldline = t[0].split("\n").last.to_s + t[1]
            puts "Oldline: " + oldline.color(:red)
            localreplacement = @replacement.nil?? ask('Type substitution string') : @replacement
            i = 1
            t[1].match(@regex).captures.each do |capture|
              localreplacement = localreplacement.gsub("\\#{i}" ,capture )
              i = i + 1
            end
            newline = t[0].split("\n").last.to_s + localreplacement + t[2].split("\n").first.to_s
            puts "Newline: " + newline.color(:green)
            if agree("Agree? y/n".color(:blue))
              tmpFile << localreplacement
            else
              tmpFile << t[1]
            end
          else
            fileContent = t[2]
            tmpFile << t.join
          end
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
    @fileNames.send(name,*args)
  end
  def [](i)
    File.new(@fileNames[i], 'r')
  end
  def each
    return to_enum if !block_given?
    @fileNames.each do |fileName|
      yield(File.new(fileName,'r'))
    end
  end
  def collect
    return to_enum if !block_given?
    @fileNames.collect do |fileName|
      yield(File.new(fileName, 'r'))
    end
  end
  def map
    return to_enum if !block_given?
    @fileNames.map do |fileName|
      yield(File.new(fileName, 'r'))
    end
  end
end
