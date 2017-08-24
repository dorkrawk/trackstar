class Trackstar::Post

  DEFAULT_FIELDS = { subject: :to_s, hours: :to_f, notes: :to_s } # hardcode for now

  attr_accessor :values

  def initialize
    @fields = DEFAULT_FIELDS
    @values = {}
    now = Time.now
    @values[:timestamp] = now.to_i
    @values[:date_time] = date_time_format(now)
  end

  def build
    puts "New Post For #{@values[:date_time]}:"
    puts "---------------------"
    @fields.each do |key, casting_method|
      begin
        puts "#{key}: "
        @values[key] = gets.chomp.send(casting_method)
      rescue => e
        puts "Sorry, that's not a valid input for #{key}. Let's try this again..."
        retry
      end
    end
    puts ""
  end

  def preview
    @values.each do |key, value|
      puts "#{key}: #{value}"
    end
  end

  private

  def date_time_format(timestamp)
    timestamp.strftime("%b %e %Y %l:%M %P")
  end

end
