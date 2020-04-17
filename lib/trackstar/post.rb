class Trackstar::Post

  DEFAULT_FIELDS = { subject: :to_s, hours: :to_f, notes: :to_s } # hardcode for now

  attr_accessor :values
  attr_reader :fields

  def initialize
    @fields = DEFAULT_FIELDS
    @values = {}
    now = Time.now
    @values[:timestamp] = now.to_i
    @values[:date_time] = date_time_format(now)
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
      post_file.puts "date: #{@values[:date_time]}"
      post_file.puts "subject: #{@values[:subject]}"
      post_file.puts "hours: #{@values[:hours]}"
      post_file.puts "-" * 20
      post_file.puts @values[:notes]
    end
    post_file_path
  end

  private

  def date_time_format(timestamp)
    timestamp.strftime("%b %e %Y %l:%M %P")
  end

end
