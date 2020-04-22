require_relative "trackstar/version"
require_relative "trackstar/post"
require_relative "trackstar/log_helper"
require_relative "trackstar/log"

module Trackstar
  def self.call(options)
    if options[:new]
      Trackstar::LogHelper.setup_log
    elsif Trackstar::LogHelper.check_for_existing_log(Dir.pwd)
      if options[:destroy]
        Trackstar::LogHelper.destroy_log
      elsif options[:stats]
        Trackstar::LogHelper.show_stats
      elsif options[:post]
        Trackstar::LogHelper.create_post
      elsif options[:list]
        Trackstar::LogHelper.list_posts(options[:limit])
      end
    else
      Trackstar::LogHelper.missing_log
    end
  end
end
