class Trackstar::Log

  CONFIG_FILE_NAME = 'trackstar.yaml'
  POSTS_DIR = 'posts'

  attr_reader :name

  def initialize
    @config_yaml = load_config_yaml 
    @name = @config_yaml['log_name']
  end  

  def build_post
    new_post = Trackstar::Post.new
    puts "New Post For #{@name}"
    puts "#{new_post.values[:date_time]}"
    puts "---------------------"
    new_post.fields.each do |key, casting_method|
      begin
        puts "#{key}: "
        new_post.values[key] = gets.chomp.send(casting_method)
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

  def last_post_file_name
    Dir["#{POSTS_DIR}/*.md"].sort.last
  end

  def first_post_file_name
    Dir["#{POSTS_DIR}/*.md"].sort.first
  end

  # stats methods

  def post_count
    Dir["#{POSTS_DIR}/*"].count { |file| File.file?(file) }
  end

  def total_hours
    posts.map { |post| post.values[:hours].to_f }.inject(0, :+)
  end

  private
  def load_config_yaml
    config_path = File.join(Dir.pwd, CONFIG_FILE_NAME)
    config = YAML.load_file(config_path)
    config
  end
end
