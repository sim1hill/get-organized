require 'pry'

class GetOrganizedByMonth

  #searches through files in the current working directory
  #looks at the filename of the current working directory 
  #takes an argument of categories to group by
  attr_reader :t, :file, :year

  MONTHS =[{1 => "January"},{2 => "February"},{3 => "March"}, {4 => "April"}, {5 => "May"}, {6 => "June"}, {7 => "July"}, {8 => "August"}, {9 => "September"}, {10 => "October"}, {11 => "November"}, {12 => "December"}]

  def initialize(files)
    binding.pry
    @file = files.first 
    @file_created = File.birthtime(@file) 
   if @file.scan(/directory/).count > 0 
        files.each.with_index do |file, i|
          puts "this file is a directory!" 
          @file = files[i + 1]
          @file_created = File.birthtime(@file)
          search_files(@file)
          if files[-1] == files[i] 
            FileUtils.cd(files[0])
            GetOrganizedByWeek.new(Dir.glob("*")).search_files
        end
      end
    end
    
  
  end

  def month_name
    month = "nada"
    MONTHS.each do |month_hash| 
      if month_hash.has_key?(@file_created.to_a[4])
        month = month_hash.values_at(@file_created.to_a[4])
      end
    end
    month.first.downcase
  end

  def file_exist?(month_directory)
    if File.directory?(month_directory)
      true
    else
      false
    end
  end

  def message
    puts "#{@file} has been moved to the #{month_name}_#{year}_directory folder"
  end

  def search_files(file)
    @year = @file_created.to_a[5]
     if @file_created.to_a[4] == time[4]
        unless file_exist?("#{month_name}_#{@year}_directory")
          FileUtils.mkdir("#{month_name}_#{@year}_directory")
          FileUtils.mv(file, "#{month_name}_#{@year}_directory")
          message
        else 
          FileUtils.mv(file, "#{month_name}_#{@year}_directory")
          message
        end
    elsif @file_created.to_a[4] < time[4]
      unless file_exist?("#{month_name}_#{@year}_directory")
        FileUtils.mkdir("#{month_name}_#{@year}_directory")
        FileUtils.mv(file, "#{month_name}_#{@year}_directory")
        message
      else
        FileUtils.mv(file, "#{month_name}_#{@year}_directory")
          message
      end
  end
end

  def time
   @t = Time.now.to_a
   @t
  end


end

class GetOrganizedByWeek
  attr_accessor :file, :file_created, :files

WEEKS = ["Week1", "Week2", "Week3", "Week4"]


  def initialize(files)
    @file = files.first  
    @files = files
    @file_created = File.birthtime(@file)
    if @file.scan(/^week/).count > 0 
        files.each.with_index do |file, i|
          puts "this file is a directory!" 
          @file = files[i + 1] 
          if files[-1] == files[i] 
            FileUtils.cd(files[0])
            GetOrganizedByWeek.new(Dir.glob("*")).search_files
        end
      end
    end
  end


  def file_exist?(week_directory)
    if File.directory?(week_directory)
      true
    else
      false
    end
  end


  def search_files
    if @file_created.to_a[3] >= 1 && @file_created.to_a[3] <= 7
        unless @files.include?(WEEKS[0])
          make_dir(WEEKS[0])
          move_file(WEEKS[0])
        else 
          move_file(WEEKS[0])
        end
    elsif @file_created.to_a[3] >= 8 && @file_created.to_a[3] <= 14
      unless @files.include?(WEEKS[1])
          make_dir(WEEKS[1])
          move_file(WEEKS[1])
        else 
          move_file(WEEKS[1])
        end
    elsif @file_created.to_a[3] >= 15 && @file_created.to_a[3] <= 21
      unless @files.include?(WEEKS[2])
          make_dir(WEEKS[2])
          move_file(WEEKS[2])
        else 
          move_file(WEEKS[2])
        end
    else
      unless @files.include?(WEEKS[3])
          make_dir(WEEKS[3])
          move_file(WEEKS[3])
        else 
          move_file(WEEKS[3])
        end
    end
end

        
      def make_dir(week)
        FileUtils.mkdir("#{week}")
      end

      def move_file(week)
        FileUtils.mv(@file, "#{week}")
      end

end



class RunGetOrganized

  def initialize
    GetOrganizedByMonth.new(Dir.glob("*"))
  end

end 

RunGetOrganized.new
