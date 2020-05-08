require 'active_support/core_ext'

class Trackstar::Log

  CONFIG_FILE_NAME = 'trackstar.yaml'
  POSTS_DIR = 'posts'
  DEFAULT_FIELDS = { subject: :to_s, hours: :to_f, notes: :to_s }
  MULTILINE_FIELDS = [:notes]
  DEFAULT_FORMATTING = { hours: :hr_after }

  attr_reader :name, :fields, :formatting

  def initialize
    @config_yaml = load_config_yaml 
    if @config_yaml['post_fields']
      @fields = @config_yaml['post_fields'].transform_keys(&:to_sym).transform_values(&:to_sym)
    else
      @fields = DEFAULT_FIELDS
    end
    if @config_yaml['post_formatting']
      @formatting = @config_yaml['post_formatting'].transform_keys(&:to_sym).transform_values(&:to_sym)
    else
      @formatting = DEFAULT_FORMATTING
    end
    @name = @config_yaml['log_name']
  end  

  def build_post
    new_post = Trackstar::Post.new
    puts "New Post For #{@name}"
    puts "#{new_post.values[:date]}"
    puts "---------------------"
    new_post.fields.each do |key, casting_method|
      begin
        if MULTILINE_FIELDS.include?(key)
          puts "#{key} (press [tab][enter] to end entry):"
          new_post.values[key] = gets("\t\n").chomp.send(casting_method)
        else
          puts "#{key}: "
          new_post.values[key] = gets.chomp.send(casting_method)
        end
      rescue => e
        puts "Sorry, that's not a valid input for #{key}. Let's try this again..."
        retry
      end
    end
    puts ""
    new_post
  end

  def posts
    @posts ||= Dir["#{POSTS_DIR}/*.md"].sort.map do |file|
      Trackstar::Post.new(file)
    end
  end

  def current_week_posts
    start_of_week_timestamp = DateTime.now.beginning_of_week.to_time.to_i
    @current_week_posts ||= posts.select { |p| p.values[:timestamp].to_i > start_of_week_timestamp }
  end

  # stats methods

  def post_count
    Dir["#{POSTS_DIR}/*"].count { |file| File.file?(file) }
  end

  def current_week_post_count
    current_week_posts.count
  end

  def count_hours(post_list=posts)
    post_list.map { |post| post.values[:hours].to_f }.inject(0, :+)
  end

  def total_hours
    count_hours
  end

  def current_week_hours
    count_hours(current_week_posts)
  end

  private
  def load_config_yaml
    config_path = File.join(Dir.pwd, CONFIG_FILE_NAME)
    config = YAML.load_file(config_path)
    config
  end
end
