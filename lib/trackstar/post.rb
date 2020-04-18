require 'pathname'

class Trackstar::Post

  DEFAULT_FIELDS = { subject: :to_s, hours: :to_f, notes: :to_s } # hardcode for now

  attr_accessor :values
  attr_reader :fields

  def initialize(path = nil)
    @fields = DEFAULT_FIELDS
    @values = {}
    
    if path
      load_from_path(path)
      # note this doesn't load the text of the post
    else
      now = Time.now
      @values[:timestamp] = now.to_i
      @values[:date] = date_time_format(now)
    end
  end

  def preview
    @values.each do |key, value|
      puts "#{key}: #{value}"
    end
  end

  def file_name
    "#{@values[:timestamp]}-#{subject_stub}.md"
  end

  def subject_stub
    Trackstar::LogHelper.stubify(@values[:subject])
  end

  def persist!
    post_file_path = "#{Trackstar::LogHelper::POSTS_DIR}/#{file_name}"
    File.open(post_file_path, 'w') do |post_file|
      post_file.puts "date: #{@values[:date]}"
      post_file.puts "subject: #{@values[:subject]}"
      post_file.puts "hours: #{@values[:hours]}"
      post_file.puts "-" * 20
      post_file.puts @values[:notes]
    end
    post_file_path
  end

  private

  def load_from_path(path)
    pn = Pathname.new(path)
    @values[:timestamp] = pn.basename.to_s.split('-').first
    File.readlines(path).each do |line|
      break if line[0] == "-"
      line.gsub!(/\n?/, "")
      split_line = line.split(": ")
      key = split_line.first
      value = split_line.last
      @values[key.to_sym] = value
    end
    
  end

  def date_time_format(timestamp)
    timestamp.strftime("%b %e %Y %l:%M %P")
  end

end
