require "fileutils"
require "yaml"

class Trackstar::LogHelper

  CONFIG_FILE_NAME = 'trackstar.yaml'
  POSTS_DIR = 'posts'
  YESES = %w(y yes yep sure uhhuh ok)

  def self.print_trackstar_logo
    puts "*" * 15
    puts "🏃‍♂️ Trackstar 🏃‍♂️"
    puts "*" * 15
    puts ""
  end

  def self.set_up_install_path
    install_path = Dir.pwd
    existing_log = self.check_for_existing_log(install_path)
    if existing_log
      puts "There seems to already be a Trackstar log here."
      false
    else
      install_path
    end
  end

  def self.check_for_existing_log(dir_path)
    config_path = File.join(dir_path, CONFIG_FILE_NAME)
    FileTest.exists?(config_path)
  end

  def self.config_yaml
    config_path = File.join(Dir.pwd, CONFIG_FILE_NAME)
    config = YAML.load_file(config_path)
    config
  end

  def self.missing_log
    puts "Sorry, there doesn't seem to be a Trackstar log here."
    puts "Enter `trackstar -n` to create a new log."
  end

  def self.set_up_name
    name = ""
    while name.empty?
      puts "So, what do you want to call this log?"
      name = gets.chomp.to_s
    end
    name
  end

  def self.stubify(string)
    stub = string
    stub.gsub(/[^0-9a-z ]/i, '').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr('-', '_').
    gsub(/\s/, '_').
    gsub(/__+/, '_').
    downcase
  end

  def self.create_log(log_options)
    base_path = log_options[:install_path]
    FileUtils.mkdir_p(base_path)
    self.create_config(log_options)
    FileUtils.mkdir_p(File.join(base_path, POSTS_DIR))
  end

  def self.create_config(log_options)
    base_path = log_options[:install_path]
    File.open(File.join(base_path, CONFIG_FILE_NAME), 'w') do |config_file|
      config_file.puts "# Trackstar log config"
      config_file.puts ""
      config_file.puts "log_name: #{log_options[:name]}"
      config_file.puts "stub: #{log_options[:name_stub]}"
      config_file.puts "post_fields:"
      Trackstar::Log::DEFAULT_FIELDS.each do |field_name, conversion_method|
        config_file.puts "  #{field_name.to_s}: #{conversion_method.to_s}"
      end
      config_file.puts "post_formatting:"
      Trackstar::Log::DEFAULT_FORMATTING.each do |field_name, format|
        config_file.puts "  #{field_name.to_s}: #{format.to_s}"
      end
    end
  end

  def self.setup_log
    self.print_trackstar_logo
    log_options = {}
    puts "Ok! Let's set up your Trackstar log!"
    puts "------------------------------------"
    log_options[:name] = self.set_up_name
    log_options[:name_stub] = self.stubify(log_options[:name])
    install_path_root = self.set_up_install_path
    log_options[:install_path] = File.join(install_path_root, log_options[:name_stub])
    puts "Here's what we're going to set up:"
    puts "  log name:         #{log_options[:name]}"
    puts "  name stub:        #{log_options[:name_stub]}"
    puts "  install location: #{log_options[:install_path]}"
    puts ""
    puts "Sounds good? (y/n)"
    confirmation = gets.chomp.downcase
    if YESES.include?(confirmation)
      self.create_log(log_options)
      puts "Ok, you're good to go."
    else
      puts "Ok, maybe next time."
    end
  end

  def self.destroy_log
    self.print_trackstar_logo
    puts "Whoa! We're going to destroy your Trackstar log."
    post_count = self.post_count
    puts "That means deleting all #{post_count} posts."
    puts "Do you really want to do this? (y/n)"
    confirmation = gets.chomp.downcase
    if YESES.include?(confirmation)
      system "rm #{CONFIG_FILE_NAME}"
      system "rm -r #{POSTS_DIR}"
      puts "BOOM. gone."
    else
      puts "Ok, this log lives another day."
    end
  end

  def self.create_post
    self.print_trackstar_logo
    log = Trackstar::Log.new
    new_post = log.build_post
    puts "Ok, here's your post:"
    puts "-" * 10
    new_post.preview
    puts "-" * 10
    puts "Look good? (y/n)"
    confirmation = gets.chomp.downcase
    if YESES.include?(confirmation)
      post_file_name = new_post.persist!
      puts "Post saved as #{post_file_name}"
    else
      puts "Try again? (y/n)"
      confirmation = gets.chomp.downcase
      self.create_post if YESES.include?(confirmation)
    end
  end

  def self.list_posts(limit)
    log = Trackstar::Log.new
    puts "The #{limit} most recent posts from #{log.name}"
    puts "-" * 10
    log.posts.first(limit).reverse.each do |post|
      puts "#{post.values[:date]}: #{post.values[:subject]}"
    end
  end

  def self.show_stats
    self.print_trackstar_logo
    log = Trackstar::Log.new
    first_post = log.posts.first
    last_post = log.posts.last
    puts "Stats for #{log.name}"
    puts "-" * 20
    puts "total post count: #{log.post_count}"
    puts "total hours: #{log.total_hours}"
    puts "post count this week: #{log.current_week_post_count}"
    puts "hours this week: #{log.current_week_hours}"
    puts "first post: #{first_post.values[:date]} - #{first_post.values[:subject]}"
    puts "last post: #{last_post.values[:date]} - #{last_post.values[:subject]}"
  end

end
