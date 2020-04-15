require "fileutils"
require "yaml"

class Trackstar::LogHelper

  CONFIG_FILE_NAME = 'trackstar.yaml'
  POSTS_DIR = 'posts'
  YESES = %w(y yes yep sure uhhuh ok)

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

  def self.post_count
    Dir["#{POSTS_DIR}/*"].count { |file| File.file?(file) }
  end

  def self.missing_log
    puts "Sorry, there doesn't seem to be a Trackstar log here."
  end

  def self.set_up_name
    puts "So, what do you want to call this?"
    # add execption catching and good stuff like that
    name = gets.chomp
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
    end
  end

  def self.setup_log
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
    post_builder = Trackstar::Post.new
    post_builder.build
    puts "Ok, here's your post:"
    puts "-" * 10
    post_builder.preview
    puts "-" * 10
    puts "Look good? (y/n)"
    confirmation = gets.chomp.downcase
    if YESES.include?(confirmation)
      post_file_name = self.persist_post(post_builder)
      puts "Post saved as #{post_file_name}"
    else
      puts "Try again? (y/n)"
      confirmation = gets.chomp.downcase
      self.create_post if YESES.include?(confirmation)
    end
  end

  def self.show_stats
    log_name = self.config_yaml['log_name']
    puts "Stats for #{log_name}"
    puts "-" * 20
    puts "post count: #{self.post_count}"
    last_post = Dir["#{POSTS_DIR}/*.md"].last
    puts "last post: #{last_post}"
  end

  def self.persist_post(post)
    subject_stub = self.stubify(post.values[:subject])
    post_file_name = "posts/#{post.values[:timestamp]}-#{subject_stub}.md"
    File.open(post_file_name, 'w') do |post_file|
      post_file.puts "date: #{post.values[:date_time]}"
      post_file.puts "subject: #{post.values[:subject]}"
      post_file.puts "hours: #{post.values[:hours]}"
      post_file.puts "-" * 20
      post_file.puts ""
      post_file.puts post.values[:notes]
    end
    post_file_name
  end
end
